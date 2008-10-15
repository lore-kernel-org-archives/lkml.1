Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbYJONju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbYJONju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 09:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYJONjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 09:39:42 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:63154 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbYJONjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 09:39:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oOONwyC620xe3mjRcn1Q72KXuE0FnBzw/zksPxtU+KCJuwd0r9WpzHHfaUU1MosaGA
         Pfz4qXhjlFIIo8Ad4VhvL9a3efX2DxmOc9k57bFB22Ri5JzwuCuYJqsA5MfRWtR5NlgS
         BvJFDERapNRja69x0AO/m8sDLwkoVZr1H6Vp8=
Message-ID: <b6a2187b0810150639j37ed3be6v3c800fb7d3a4a1f0@mail.gmail.com>
Date: Wed, 15 Oct 2008 21:39:39 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: linux 2.6.27 kernel panic on x86 - please revert commit 3a85e770aa77e4f1a4096275c97b64c10cd7323e
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
In-Reply-To: <20081015120558.GA23347@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0810151902510.19590@boston.corp.fedex.com>
	 <20081015112324.GB31476@elte.hu>
	 <b6a2187b0810150502m3b363b90q106102578e92811d@mail.gmail.com>
	 <20081015120558.GA23347@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 8:05 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> Unsetting CONFIG_COMPAT_VDSO solves the issue.
>>
>> Thanks for your help, and sorry for the fault alarm. Did take a while
>> to trace it down to the commit.
>
> hm, setting the option should not break new glibc so this is a
> regression and we've still got a bug to fix.

Something must have triggered the bug. Every single linux git update
has been ok with CONFIG_COMPAT_VDSO=y until now, and I had glibc-2.7
since Dec 2007.

Jeff.
