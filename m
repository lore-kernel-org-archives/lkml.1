Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690AbZIBWmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbZIBWmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 18:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbZIBWmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 18:42:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59514 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbZIBWmn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 18:42:43 -0400
From: Christian =?iso-8859-1?q?Kr=E4mer?= <christian@kraemer-eu.de>
Organization: Privat
To: Frans Pop <elendil@planet.nl>
Subject: Re: yenta_socket: PCMCIA-Cards are not recognised by kernel
Date: Thu, 3 Sep 2009 00:42:44 +0200
User-Agent: KMail/1.9.9
References: <200909021856.29565.christian@kraemer-eu.de> <200909021953.02190.elendil@planet.nl>
In-Reply-To: <200909021953.02190.elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200909030042.45081.christian@kraemer-eu.de>
X-Provags-ID: V01U2FsdGVkX1/pRK6UgJe6FhYUanT656aXWyDhBrvr3v1U3+p
 DnRTkBz2eO2TkERJZ68Fb7iTLNuZwWkorJhJ9FtuNiExHmLorT
 0xBQyCu1V01JOHKF9HGraiY9Fv6rfOG
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frans,

Thank you very much indeed for your answer!

On Wednesday 02 September 2009 19:53:01 you wrote:
> Christian Krämer wrote:
> > I used a Gentoo LiveCD (Kernel 2.6.24-gentoo-r7; Platform: x86)
>
> That's a pretty old kernel. Any chance that you can try with a more recent
> one, such as 2.6.30? Or maybe just a more recent Gentoo CD or live CD from
> another distribution?
>
> Also, did you see these following messages?
>

I also tried to install gentoo offline (with a portage snapshot and manually 
downloaded distfiles). The snapshot was form the 14th August 2009. At this 
time the source packet "gentoo-sources-2.6.30-r4" was the current stable for 
the x86 platform, which I used.

Maybe the output in some cases may variey, but at all I had the same problem: 
dmesg only shows that a card was inserted or ejected and also lspci doesn't 
listed the card (without the -H1 parameter).

After that i first tried some other *nixes, but with moderatly success.
But 'cause Linux is my favorite os, I thought, I try it with posting here on 
the mailing list.

> > pcmcia: Detected deprecated PCMCIA ioctl usage from process: hwsetup.
> > pcmcia: This interface will soon be removed from the kernel; please
> > expect breakage unless you upgrade to new tools.
> > pcmcia: see
> > http://www.kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html for
> > details.

I read this page also before, but it doesn't help. eg. pcmcia-socket-startup
doesn't help and the bridge problem with the subordinate doesn't fit, but I 
already have tried the "pci=assign-busses" commandline already, unfortunately 
without success.

> > warning: process `hwsetup' used the deprecated sysctl system call with
> > 1.49. warning: process `hwsetup' used the deprecated sysctl system call
> > with 1.49.
>
> It looks as if that Gentoo CD is still using the deprecated pcmcia-cs
> utilities instead of the new pcmciautils.

That's an idea, but in the installed gentoo system there where no hwsetup 
utility (only the usual init scrips, which simply loaded the necessary 
modules). I admit, that I don't know what exacly hwsetup does, but it seems 
that it only look what devices are present and load the needed kernel 
modules.

Maybe the following information will help to solve the Problem:

* On FreeBSD the system freezes when i insert the card and the kernel fire 
frequently messages of an "interrupt storm", and that it would throttle it. 
(That's the reason why I referred at the interrupt routing difference between 
lspci with the "special Intel"-detection Method and without. I'm not very 
familiar with lowlevel development and don't now whether this matters or 
not...)


If you think it could help to install a new kernel or you need some 
information or output, please tell me, it's no problem to install gentoo (or 
any other distribution) with a specific kernel (and maybe some patches)

>
> Hope that helps,
> FJP


