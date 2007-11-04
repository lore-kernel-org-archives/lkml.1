Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbXKDJ34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbXKDJ34 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 04:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbXKDJ3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 04:29:49 -0500
Received: from antispam.upcomillas.es ([130.206.70.245]:48174 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbXKDJ3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 04:29:47 -0500
Subject: Re: 2.6.34-rc1 eat my photo SD card :-(
From: Romano Giannetti <romanol@upcomillas.es>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071102182833.2c055446@poseidon.drzeus.cx>
References: <1193918202.8439.7.camel@rukbat>
	 <20071102182833.2c055446@poseidon.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1
Date: Sun, 04 Nov 2007 10:29:43 +0100
Message-Id: <1194168583.10245.15.camel@rukbat>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-11-02 at 18:28 +0100, Pierre Ossman wrote:
> On Thu, 01 Nov 2007 12:56:42 +0100
> Romano Giannetti <romanol@upcomillas.es> wrote:
> 
> Data loss is never fun. I hope you didn't have anything important on the card.
> 

Well. A cousin-in-law marriage, would have been best not to lose it, but
I'll survive.

> > I have a flight waiting now, so I have put all the dmesgs and syslogs
> > over there:
> > 
> > http://www.dea.icai.upcomillas.es/romano/linux/info/2624-rc1-mmc/
> > 

Hmmm... the Uni server is down today. Darn.

> I'm afraid the logs are of little help. They are just filled with
> noise from the file system. You also seem to prove the FAT code to
> give an invalid pointer (the oops in the first dmesg).
> 

Ok, I suspected it.

> Can you reproduce this? To help you I need to see the errors given by
> the MMC layer. You should also try reproducing it without a tainted
> kernel (i.e. don't load ndiswrapper).

I have a spare 128M card I can use to try. The one that failed was a 2G
one. I will try to reproduce without tainting the kernel (unfortunately,
the Atheros chip I have is not supported by ath5k yet, and the choice is
between ndiswrapper or Vista.). Should I enable some debugging option
for the MMC layer?  


> Rgds
-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
