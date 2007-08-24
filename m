Return-Path: <linux-kernel-owner+w=401wt.eu-S1759806AbXHXPiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759806AbXHXPiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 11:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755680AbXHXPht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 11:37:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45538 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757282AbXHXPhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 11:37:48 -0400
Subject: Re: TV card detected wrongly by the kernel. Any chance to get this
	fixed?
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <fak8ei$jg1$1@sea.gmane.org>
References: <fai89b$ms1$1@sea.gmane.org> <20070822215148.GL30705@stusta.de>
	 <1187823357.7104.25.camel@gaivota> <fak8ei$jg1$1@sea.gmane.org>
Content-Type: text/plain; charset=utf-8
Date: Fri, 24 Aug 2007 12:37:42 -0300
Message-Id: <1187969862.6621.85.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.90-1mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Em Qui, 2007-08-23 às 17:23 +0200, Manuel Reimer escreveu:
> Mauro Carvalho Chehab wrote:
> > If your board have an unique PCI ID, we may add it to the driver,
> > avoiding this need. For this, we will need the results of the following
> > command:
> > 
> > lspci -vv -nn
> 
> I'm using card=65 to use my card. I never tried the tuner (don't need 
> it) but the composite-in works for displaying the input of my sattelite 
> receiver and I'm able to read videotext, too. Without "card=65", I only 
> got black/white output...

> 00:10.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 
> Video Capture [109e:036e] (rev 11)

I can't see and subsystem ID. Since it is not on the few range of boards
where we know other ways for detecting the board internals, there's no
known way for auto-detecting your board.

The solution for you is to add:
	options bttv card=65
into /etc/modprobe.conf (or /etc/modules.conf, or /etc/modules -
depending on your distro).

This way, every time the driver is loaded, the card=65 option will
automatically be used by the bttv driver.

-- 
Cheers,
Mauro

