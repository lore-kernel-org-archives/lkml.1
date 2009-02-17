Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbZBQQvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbZBQQvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 11:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbZBQQv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 11:51:28 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:51641 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbZBQQv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 11:51:27 -0500
From: Philippe Grenard <philippe.grenard@laposte.net>
To: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: cannot get stable system since 2.6.28 kernel (amd64)
Date: Tue, 17 Feb 2009 17:51:52 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.27.10-phiphi; KDE/4.2.0; x86_64; ; )
Cc: "John Stoffel" <john@stoffel.org>
References: <200902131944.56634.philippe.grenard@laposte.net> <200902161925.40256.philippe.grenard@laposte.net> <18842.16695.145336.851447@stoffel.org>
In-Reply-To: <18842.16695.145336.851447@stoffel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902171751.52961.philippe.grenard@laposte.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 February 2009 05:46:47 John Stoffel wrote:
> >>>>> "Philippe" == Philippe Grenard <philippe.grenard@laposte.net> writes:
>
> Philippe> well, I don't really believe in hardware problem for two
> Philippe> reasons : 1st, nearly all my hardware is quite new ( < 1
> Philippe> year old ), which is, I agree, not a solid proof ;-) 2nd,
> Philippe> the problem is really repetitive : every time I boot on
> Philippe> older kernel, everything works like a charm, every time I
> Philippe> boot on the newer kernel, I end up crashing : the "random"
> Philippe> part is only the time before crash....
>
> Philippe> I haven't any "overclocking" settings, and every hardware
> Philippe> and bios settings are the same : same computer, same
> Philippe> harddisk partition, and so on.  2.6.28 will everytime stop
> Philippe> after "Booting the kernel".  2.6.29-rc* will boot, but then
> Philippe> stalls after a random delay... Except the "/proc/cpuinfo"
> Philippe> difference between the two kernels, I don't have a clue....
>
> Philippe> The thing is I can continue using the old kernel, but I
> Philippe> thought I better report this since It could hide some
> Philippe> regression on amd64 systems ?
>
> It's certainly sounding like a regression, or misconfiguration
> somewhere.  Can you start doing a 'git bisect' routine on this to see
> if you can find the commit which causes this regression?
>

hem..... I've tried it the "old way" somehow ;-)

> It will take around 10 or some recompiles and reboots, but should do
> the trick, or at least help narrow things down alot.  Read
> Documentation/BUG-HUNTING ofr how to do a bisect run.
>
> You could also go back and re-build your 2.6.28 kernel and config from
> scratch to confirm that it's really working properly.  Then, jump to
> 2.6.29-rc5 (just released) and do a 'make oldconfig' and see what
> you're prompted for.  If it still crashes, send us the original
> config, and a diff to the new config (diff -u) so we can look it over.
Well, for the moment 2.6.28 does not even boot.... so I'll try to install the 
latest 2.6.27.xx and then make the "oldconfig" on 2.6.29-rc5

If you have some kind of "minimalist config file", i'll gladly test that, even 
if it means that I miss some features....(as soon as I can have harddisk, even 
without proper network, system could boot and I may be able to see if that 
config works)
>
> Also, make sure you're not running *any* binary kernel modules, since
> that will make us completely ignore you.  We can't debug issues like
> this when nVidia graphics modules are in the system since we can't
> tell what that module does to the rest of the kernel and it's not
> worth ou time to figure out.
Yep, understood that : I wont build it anymore for the moment (I was 
optimistic up to now : every new kernel was installed along nvidia module 
without problem ;-) )
>
> I'm running 2.6.29-rc3 on my AMD64 system and it's been nice and
> stable and my hardware too is under a year old.
>
For info, my motherboard is an Asus P5Q3 Deluxe, the processor is Core2Duo 
E8400, and harddisk is 250Go Seagate, Graphic card is Nvidia GeForce 9600 GT
I suspect some motherboard feature here... 
I haven't tried to modified my dsdt table for the moment neither .

> John

Thanks for your help,

Philippe
