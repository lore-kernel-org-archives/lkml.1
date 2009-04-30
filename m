Return-Path: <linux-kernel-owner+w=401wt.eu-S934009AbZD3RwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934009AbZD3RwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932815AbZD3R15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:27:57 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:33534 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765464AbZD3R1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:27:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=BPViVAXlyTpd1niyFl3cxxJN+fIVSlTFUPqOZOOf1au0zJyCoXWaeotiTdrA9jgl/s
         4jMJ3BZAfAwdeTaVEWmVOPX+xE/EIKQ0YtiQ8xgWTV8l+GqULNvs8+uIrStDwn2LIZ1v
         E83E/6lYVYxM58WOkm6KHQ7RHuB+VhBs48OIw=
Message-ID: <49F9DF96.7090108@gmail.com>
Date: Thu, 30 Apr 2009 19:27:50 +0200
From: Artur Skawina <art.08.09@gmail.com>
User-Agent: Thunderbird 2.0.0.22pre (X11/20090422)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: akataria@vmware.com, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Default HZ value for X86
References: <1240873630.14713.25.camel@alok-dev1> <20090428003454.08d1660c@lxorguk.ukuu.org.uk>
In-Reply-To: <20090428003454.08d1660c@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Mon, 27 Apr 2009 16:07:10 -0700
> Alok Kataria <akataria@vmware.com> wrote:
>>
>> I was wondering why do we still have the default HZ value as 1000 for
>> the x86 kernels.
>>
>> arch/x86/configs/i386_defconfig:CONFIG_HZ=1000
>> arch/x86/configs/x86_64_defconfig:CONFIG_HZ=1000
>>
>> With the highres timer implementation it was planned to move away from
>> relying on high timer interrupt frequency for applications requiring
>> precise high resolution timers.
> 
> With the tickless kernel does this really matter any more ? We might as

It didn't matter much, until the kernel stopped actually being tickless.
These days, w/ ints on when nonidle, it probably does again...

> well keep a logical 1000 for convenience and accuracy.

