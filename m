Return-Path: <linux-kernel-owner+w=401wt.eu-S1759509AbYEXAKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509AbYEXAKB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 20:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYEXAJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 20:09:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:63217 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbYEXAJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 20:09:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GnesqwNJr72qcWgbMJvDZINuwvuEU+UseM0gvk+VK6iKoWUFuJ3lexotE0JJfyaIY3BYzFBrotV/gics1+Z7XhJJtI3dy8vUqawhdTZDyEA7DGLkJsVCev1q/c6LS8cwRfMXyGZEaD0i63rakwrYmbHYOIs2E5FP1kJfdrhrYPY=
Message-ID: <86802c440805231709n148d7e0bt130b833dec3a3f26@mail.gmail.com>
Date: Fri, 23 May 2008 17:09:52 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] x86: extend e820 ealy_res support 32bit - fix v2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440805231701p4dbcef68m19173bb53ed7904e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805110030.15510.yhlu.kernel@gmail.com>
	 <200805180118.57863.yhlu.kernel@gmail.com>
	 <200805211840.18619.yhlu.kernel@gmail.com>
	 <200805221520.19259.yhlu.kernel@gmail.com>
	 <86802c440805231608g314690fu3125034804ac51fd@mail.gmail.com>
	 <4837558E.40705@goop.org>
	 <86802c440805231701p4dbcef68m19173bb53ed7904e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 5:01 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Fri, May 23, 2008 at 4:38 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>> Yinghai Lu wrote:
>>>
>>> Jeremy,
>>>
>>> your config works on XEN of 5.2 as domU
>>> ( I added ext2 support...)
>>>
>>
>> The boot log you attached is for a kernel booting either natively or in an
>> hvm domain ("Booting paravirtualized kernel on bare hardware").  Were you
>> booting it as an hvm guest rather than a pv one?
>
> run it as FV guest.

I moved reserve_ebda_region() to i386_start_kernel from setup_arch.

and reserve_ebda_region will check if (paravirt_enabled()), wonder if
that cause problem.

but 64bit already did that.

YH
