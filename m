Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbZBPSZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbZBPSZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 13:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbZBPSZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 13:25:16 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:41211 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbZBPSZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 13:25:15 -0500
From: Philippe Grenard <philippe.grenard@laposte.net>
To: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: cannot get stable system since 2.6.28 kernel (amd64)
Date: Mon, 16 Feb 2009 19:25:40 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.27.10-phiphi; KDE/4.2.0; x86_64; ; )
Cc: "John Stoffel" <john@stoffel.org>
References: <200902131944.56634.philippe.grenard@laposte.net> <200902151317.11690.philippe.grenard@laposte.net> <18840.45474.829954.528820@stoffel.org>
In-Reply-To: <18840.45474.829954.528820@stoffel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902161925.40256.philippe.grenard@laposte.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 February 2009 01:21:54 John Stoffel wrote:
> >>>>> "Philippe" == Philippe Grenard <philippe.grenard@laposte.net> writes:
>
> Philippe> On Saturday 14 February 2009 10:24:51 Jaswinder Singh Rajput 
wrote:
> >> On Sat, Feb 14, 2009 at 1:47 PM, Philippe Grenard
> >>
> >> <philippe.grenard@laposte.net> wrote:
> >> > On Friday 13 February 2009 21:48:30 John Stoffel wrote:
> >> >> Here's your problem most probably.  The nVidia graphics module.
> >> >> Remove that and re-try your system.  Basically, we can't help you
> >> >> when you use a vendor's binary module.
> >> >>
> >> >> John
> >> >
> >> > Well, it does not change anything to my problem...
> >> > Moreover, I don't understand why this would work with 2.6.27.10 but
> >> > not with 2.6.29-rc4 ....
> >>
> >> May be nvidia graphics module was written based on some kernel which
> >> is more closer to 2.6.27.10 as compare to 2.6.29-rc4.
> >>
> >> Another thing which John is pointing configure your bios to use
> >> standard inbuild garphics card OR remove nvidia module and check
> >> whether it solves your problem or not.
> >>
> >> --
> >> JSR
>
> Philippe> As I said just before, I tried it but it does not change my
> Philippe> problem : the system still stalls randomly, sometimes during
> Philippe> boot, sometimes after...
>
> This smells even more of hardware problems then.  Did you change
> anything recently besides your kernel?  And does the system still
> reliably run with the older kernel?
>
> If you have a second Linux computer, you can setup a newconsole to
> hopefully capture and then post more details about your system when it
> boots and crashes.
>
> I'd personally pull any extra disks, re-seat memory, turn down the
> systems settings in the BIOS to very conservative numbers, etc.  No
> overclocking at all.
>
> Also, try removing all but one memory module and seeing if that helps.
>
> John
Thanks for your attention.

well, I don't really believe in hardware problem for two reasons : 
1st, nearly all my hardware is quite new ( < 1 year old ), which is, I agree, 
not a solid proof ;-)
2nd, the problem is really repetitive : every time I boot on older kernel, 
everything works like a charm, every time I boot on the newer kernel, I end up 
crashing : the "random" part is only the time before crash....

I haven't any "overclocking" settings, and every hardware and bios settings 
are the same : same computer, same harddisk partition, and so on. 
2.6.28 will everytime stop after "Booting the kernel".
2.6.29-rc* will boot, but then stalls after a random delay... Except the 
"/proc/cpuinfo" difference between the two kernels, I don't have a clue....

The thing is I can continue using the old kernel, but I thought I better 
report this since It could hide some regression on amd64 systems ? 

I'm just a regular user, so I really lack debugging experience...

Philippe
