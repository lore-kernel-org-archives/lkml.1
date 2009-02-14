Return-Path: <linux-kernel-owner+w=401wt.eu-S1751784AbZBNIR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbZBNIR1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 03:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbZBNIRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 03:17:17 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:39823 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbZBNIRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 03:17:17 -0500
From: Philippe Grenard <philippe.grenard@laposte.net>
To: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: cannot get stable system since 2.6.28 kernel
Date: Sat, 14 Feb 2009 09:17:38 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.27.10-phiphi; KDE/4.2.0; x86_64; ; )
Cc: "John Stoffel" <john@stoffel.org>, Len Brown <lenb@kernel.org>
References: <200902131944.56634.philippe.grenard@laposte.net> <200902132056.20097.philippe.grenard@laposte.net> <18837.56478.10536.6978@stoffel.org>
In-Reply-To: <18837.56478.10536.6978@stoffel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902140917.38313.philippe.grenard@laposte.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 February 2009 21:48:30 John Stoffel wrote:
> >>>>> "Philippe" == Philippe Grenard <philippe.grenard@laposte.net> writes:
>
> Philippe> On Friday 13 February 2009 19:56:54 Len Brown wrote:
> >> dmesg -- assuming you can boot far enough to capture it,
> >> may be helpful.
> >>
> >> also, disabling PREEMPT may be interesting to try.
> >>
> >> cheers,
> >> --
> >> Len Brown, Intel Open Source Technology Center
>
> Philippe> I tried to disable all "PREEMPT" options in make config,
> re-compiled 2.6.29-rc4 Philippe> and managed to get these info before
> kernel stalls :
> Philippe> (Was that what you understood by "disabling PREEMPT" ?)
>
> Philippe> I'll also try to make some diff on the different files to
> Philippe> see what changes between working 2.6.27.10 and non-working
> Philippe> 2.6.29-rc4
>
> ....
> Philippe> [   33.663143] input: btnx mouse as /class/input/input9
> Philippe> [   36.351195] nvidia: module license 'NVIDIA' taints kernel.
> Philippe> [   36.603727] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level,
> low) -> IRQ 16 Philippe> [   36.603733] nvidia 0000:01:00.0: setting
> latency timer to 64 Philippe> [   36.603892] NVRM: loading NVIDIA UNIX
> x86_64 Kernel Module  180.22  Tue Jan Philippe> 6 09:15:58 PST 2009
> Philippe> [   36.606686] IRQ 16/nvidia: IRQF_DISABLED is not guaranteed on
> shared IRQs
>
> Here's your problem most probably.  The nVidia graphics module.
> Remove that and re-try your system.  Basically, we can't help you when
> you use a vendor's binary module.
>
> John

Well, it does not change anything to my problem...
Moreover, I don't understand why this would work with 2.6.27.10 but not with 
2.6.29-rc4 ....

Thanks anyway, I didn't even thought about it... 

Philippe
