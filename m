Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbXLCIpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbXLCIpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 03:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbXLCIo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 03:44:56 -0500
Received: from antispam.upcomillas.es ([130.206.70.245]:58477 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbXLCIoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 03:44:55 -0500
Subject: Re: namespace support requires network modules to say "GPL"
From: Romano Giannetti <romanol@upcomillas.es>
To: Mark Lord <lkml@rtr.ca>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       containers@lists.osdl.org
In-Reply-To: <475227B1.2060802@rtr.ca>
References: <m163zi9425.fsf@ebiederm.dsl.xmission.com>
	 <47515D39.9030900@rtr.ca>	<20071201111736.297dd99a@freepuppy.rosehill>
	 <20071201163035.321fd554@freepuppy.rosehill>  <475227B1.2060802@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1
Date: Mon, 03 Dec 2007 09:24:15 +0100
Message-Id: <1196670255.4127.21.camel@rukbat>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 2007-12-01 at 22:34 -0500, Mark Lord wrote:
> Stephen Hemminger wrote:.
> >>
> > I spoke too soon earlier, ndiswrapper builds and loads against current
> > 2.6.24-rc3. Vmware and proprietary VPN software probably do not. Once again I don't
> > give a damn, but the enterprise distro vendors certainly care.
> ...
> 
> Naw, enterprise (or any other) distro vendors shouldn't have any issues here,
> since they can just patch their kernels around any issues.

Please pardon me for jumping in; I am not a kernel developer, but I try
to help with debugging whenever I can (and it's not just hand-waving, I
helped to track down a couple of nasty bugs on MMC or ACPI EC,
recently). And I am an engineer and IANAL, so I wouldn't speak about
laws here. But I think it's not just a distribution's problem.

Unfortunately, I need VMware and ndiswrapper to get work done with my
laptop. It's not the perfect world, but the only alternative is to boot
in XP. So I normally stick with vendors kernels and, when I have time to
"play" with new kernel, I go for it. If ndiswrapper and VMware work,
perfect, I can test extensively the new kernel; if I find problems, I
*know* I have to restart without proprietary modules, try to reproduce,
report back. I did it a lot of times.

What I think is that every time VMware or (worst) ndiswrapper breaks,
the kernel loose an awful lot of testers. In the span of time before
Giri and the VMware team post a patch (-rc1 and -rc4, tipically), my
testing activity is just occasional. And I guess a lot of people is in
the same situation. 

These are just my 2cents. I will continue to test new kernels every time
I can, and to use native solutions as often as I can (go, ath5k, go!;
and LabWindows/CVI for Linux, anyone?). But maybe a bit of tolerance can
help everyone...

Back in my hole,

		Romano 


-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
