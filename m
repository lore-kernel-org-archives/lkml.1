Return-Path: <linux-kernel-owner+w=401wt.eu-S1758384AbXEXMGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384AbXEXMGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 08:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbXEXMGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 08:06:38 -0400
Received: from ic0245.upco.es ([130.206.70.245]:55066 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005AbXEXMGg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 08:06:36 -0400
Subject: Re: [patch 00/69] -stable review
From: Romano Giannetti <romanol@upcomillas.es>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org>
References: <20070521191612.800400000@sous-sol.org> 
	<4652070D.3090509@redhat.com> 
	<alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org> 
	<20070521212522.GL3429@sequoia.sous-sol.org> 
	<1179870110.16656.2.camel@localhost> 
	<alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org>
Content-Type: text/plain;
	charset=utf-8
Date: Thu, 24 May 2007 14:06:34 +0200
Message-Id: <1180008394.15600.26.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-22 at 15:07 -0700, Linus Torvalds wrote:
>
> On Tue, 22 May 2007, Romano Giannetti wrote:
> >

> It's not known, no, and yeah, that's scary (and 60 seconds is long enough
> that most people would have grown bored and pushed the power button for
> five seconds, having considered the resume a failure).
>
> > [    1.617972] pcmcia: registering new device pcmcia1.0
> > [   61.612517] PM: Writing back config space on device 0000:00:[...]
> >

I discovered that SysRq-t works during the pause. So I pressed it more
or less halfway the pause; the full result is here:
http://www.dea.icai.upcomillas.es/romano/linux/info/dmesg-resume.txt

It seems that most of the tasks are in

[<c0138931>] refrigerator+0x41/0x60

So, I tried to suspend without any card in the pcmcia slot. Guess what?
I extracted the card and the system did not suspend. Just stopped dead.

Sigh.

	Romano


--
Romano Giannetti --- romano.giannetti@gmail.com
Sorry for the following disclaimer, it's attached by our otugoing server
and I cannot shut it up.



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation.

