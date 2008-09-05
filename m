Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbYIEQcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbYIEQcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750738AbYIEQcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:32:39 -0400
Received: from relais.videotron.ca ([24.201.245.36]:48584 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbYIEQci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:32:38 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 05 Sep 2008 12:32:32 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Takashi Iwai <tiwai@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Dmitry Torokhov <dtor@insightbb.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@osdl.org>,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] ucb1400_ts depends SND_AC97_BUS
In-reply-to: <s5hhc8u8soi.wl%tiwai@suse.de>
Message-id: <alpine.LFD.1.10.0809051231120.23787@xanadu.home>
References: <20061209003635.e778ff76.randy.dunlap@oracle.com>
 <200612092150.02940.dtor@insightbb.com>
 <20061209185737.1768315d.randy.dunlap@oracle.com>
 <200612092205.19358.dtor@insightbb.com>
 <Pine.LNX.4.64.0612092212410.2630@xanadu.home>
 <20061209210945.5abe2d89.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0612102244140.2630@xanadu.home>
 <20080904195744.f367cd2d.randy.dunlap@oracle.com>
 <alpine.LFD.1.10.0809050028590.23787@xanadu.home>
 <20080904214444.0dccf859.randy.dunlap@oracle.com>
 <alpine.LFD.1.10.0809050104560.23787@xanadu.home>
 <s5htzcvt7id.wl%tiwai@suse.de>
 <alpine.LFD.1.10.0809051049460.23787@xanadu.home>
 <s5hhc8u8soi.wl%tiwai@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2008, Takashi Iwai wrote:

> At Fri, 05 Sep 2008 10:52:25 -0400 (EDT),
> Nicolas Pitre wrote:
> > 
> > On Fri, 5 Sep 2008, Takashi Iwai wrote:
> > 
> > > > This was fixed 2 years ago.  Who broke it this time?
> > > 
> > > Oh, it must be me.
> > 
> > I think both your patch and the one I previously posted are needed.
> 
> Could you repost?  I can't find it easily now.

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 6e1e8c6..22cf319 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -219,7 +219,6 @@ config TOUCHSCREEN_ATMEL_TSADCC
 
 config TOUCHSCREEN_UCB1400
 	tristate "Philips UCB1400 touchscreen"
-	select AC97_BUS
 	depends on UCB1400_CORE
 	help
 	  This enables support for the Philips UCB1400 touchscreen interface.
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 5dba165..70355d3 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -52,6 +52,7 @@ config HTC_PASIC3
 
 config UCB1400_CORE
 	tristate "Philips UCB1400 Core driver"
+	select AC97_BUS
 	help
 	  This enables support for the Philips UCB1400 core functions.
 	  The UCB1400 is an AC97 audio codec.


Nicolas
