Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbXEXWPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbXEXWPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756577AbXEXWP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:15:26 -0400
Received: from antispam.upcomillas.es ([130.206.70.245]:34310 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbXEXWPT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:15:19 -0400
Subject: Re: Long delay in resume from RAM (Was Re: [patch 
	00/69]-stablereview)
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
In-Reply-To: <alpine.LFD.0.98.0705240815530.26602@woody.linux-foundation.org
	>
References: <20070521191612.800400000@sous-sol.org> 
	<4652070D.3090509@redhat.com> 
	<alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org> 
	<20070521212522.GL3429@sequoia.sous-sol.org> 
	<1179870110.16656.2.camel@localhost> 
	<alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org> 
	<1180008394.15600.26.camel@localhost> <1180019201.15600.57.camel@localhost>
	 <alpine.LFD.0.98.0705240815530.26602@woody.linux-foundation.org>
Content-Type: text/plain;
	charset=utf-8
Date: Fri, 25 May 2007 00:14:48 +0200
Message-Id: <1180044888.15241.39.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-24 at 08:28 -0700, Linus Torvalds wrote:

> Can you compile those two modules with PCMCIA_DEBUG=4?
>
> Something like
>
> 	make EXTRA_CFLAGS=-DPCMCIA_DEBUG=4
>

Well, I have to give up for tonight... that make do not works (see the
problem explained in other messages, some part of the kernel fails to
compile for the redefined EXTRA_CFLAGS); I naively tried to do:

     make EXTRA_CFLAGS=-DPCMCIA_DEBUG=4 drivers/pcmcia/

(which worked)

and then

     make

(alone) but the second one recompiled the  drivers/pcmcia/ subdir, too.
Too tired to think right now (good excuse), so I will try to find a bit
of time tomorrow.

Another naive doubt I have is: in 2.6.17.13, with additional patches
http://zeus2.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=d834c16516d1ebec4766fc58c059bf01311e6045
http://zeus2.kernel.org/git/?p=linux/kernel/git/brodo/pcmcia-fixes-2.6.git;a=commitdiff;h=f755c48254ce743a3d4c1fd6b136366c018ee5b2
http://zeus2.kernel.org/git/?p=linux/kernel/git/brodo/pcmcia-fixes-2.6.git;a=commitdiff;h=e6248ff596dd15bce0be4d780c60f173389b11c3

(now in the mainline), it works. And it used the cis file too.

Romano



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation.

