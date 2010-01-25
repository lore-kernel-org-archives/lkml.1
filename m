Return-Path: <linux-kernel-owner+w=401wt.eu-S1752563Ab0AYHkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab0AYHkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 02:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321Ab0AYHj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 02:39:59 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:38280 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab0AYHj6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 02:39:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=YS6yDrfomLBqZJNGVZjuoFZg160HjyD0/nUB63B9TLEYtIQL9+SfU5fu5ED7UGmfrg
         LZLGbE30ZZVwALIACjrHrVSCCHyaXfUZZ/UdGELV3aKpREPdczkvw+53DdcW6lmim+wd
         CqY6biScu0vQ3IS5ob0rBPJ6k8jGI2dv2y1o4=
MIME-Version: 1.0
In-Reply-To: <20100122172615.4a560908.akpm@linux-foundation.org>
References: <daef60381001170538o5b3b0b17l72923261b76d521@mail.gmail.com> 
	<20100122172615.4a560908.akpm@linux-foundation.org>
From: Hui Zhu <teawater@gmail.com>
Date: Mon, 25 Jan 2010 15:39:38 +0800
Message-ID: <daef60381001242339n75518e05i8f083756120cdb4c@mail.gmail.com>
Subject: Re: [PATCH] Add options to markup_oops.pl to make it support 
	cross-compiler environment better
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Sam Ravnborg <sam@ravnborg.org>,
       =?ISO-8859-1?Q?Ozan_=C7aglayan?= <ozan@pardus.org.tr>,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 23, 2010 at 09:26, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sun, 17 Jan 2010 21:38:28 +0800
> Hui Zhu <teawater@gmail.com> wrote:
>
>> Hello,
>>
>> The markup_oops.pl have 2 troubles to support cross-compiler environment:
>> 1.  It use objdump directly.
>> 2.  It use modinfo to get the message of module.
>>
>> This patch add 2 options to markup_oops.pl:
>> 1. -c CROSS_COMPILE   Specify the prefix used for toolchain.
>> 2. -m MODULE_DIRNAME  Specify the module directory name.
>>
>> After this patch, parse the x8664 oops in x86, we can:
>> cat amd64m | perl ~/kernel/tmp/m.pl -c
>> /home/teawater/kernel/bin/x8664- -m ./e.ko vmlinux
>>
>
> The other patches are wordwrapped and one still didn't apply after
> fixing that, so please just redo and resend everything.  Send them to
> yourself first and check that the result still applies OK.
>
>
> Also, we prefer patch titles to be of the form
>
>        subsystem-identifier: what was changed
>
> so a good title for this patch would have been
>
>        markup_oops.pl: add options to improve cross-sompilation environments
>

Thanks Andrew.  I will post a new mail according to your mail.

Best regards,
Hui
