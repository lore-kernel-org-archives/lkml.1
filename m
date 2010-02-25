Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab0BYGKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 01:10:46 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60751 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab0BYGKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 01:10:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=NMrg2x9F0p1Nkc4JvfGHWKakx/ocAGkFGNT+vIgZe8mIO+0Jz73N0TiVXoHfSsxFnB
         uNSvGmAx0fCMJeviVNmCfN1L/t7w8xW1DYl82cvuxXR2KCR3vuCiQX169syrf0yeqV8R
         s4LByLrXvttFLxxNwc8mb4gi+pxveh2T4d87o=
MIME-Version: 1.0
In-Reply-To: <20100224131545.951db05e.akpm@linux-foundation.org>
References: <4B829750.90107@gmail.com> <20100224131545.951db05e.akpm@linux-foundation.org>
From: Hui Zhu <teawater@gmail.com>
Date: Thu, 25 Feb 2010 14:10:23 +0800
Message-ID: <daef60381002242210x39063662xfb0152d2c395ed70@mail.gmail.com>
Subject: Re: [PATCH 0/2] markup_oops.pl and GDB: Let GDB can handle kernel 
	oops stack message
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, ozan@pardus.org.tr,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org,
       gdb-patches ml <gdb-patches@sourceware.org>,
       Michal Marek <mmarek@suse.cz>,
       Jason Wessel <jason.wessel@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 05:15, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 22 Feb 2010 22:40:16 +0800 Hui Zhu <teawater@gmail.com> wrote:
>
>> So I make a patch for markup_oops.pl to make it can convert the oops
>> message to GDB command.
>> And make a patch for GDB to add a new target empty which level is same
>> with corelow target. It can save the memory and reg operation command's
>> value and send it to GDB as the inferior's value. Then GDB can parse the
>> oops message directly.
>
> How useful is the kernel patch when one is using an unpatched gdb?
>

For that status, I have 2 ways to handle it:
1.  Change the "target empty" to other target, like "target remote
localhost:1234".
Then the remote target displace the empty target.  It can be use.

2.  In http://lkml.org/lkml/2010/1/3/28, there is a program called
s2c, it can convert some special message to a core file.  Then gdb can
parse core file.
If you think we need it, I can make it input the gdb commands.

Thanks,
Hui
