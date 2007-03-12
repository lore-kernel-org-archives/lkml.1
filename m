Return-Path: <linux-kernel-owner+w=401wt.eu-S964871AbXCLDGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964871AbXCLDGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 23:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964868AbXCLDGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 23:06:21 -0400
Received: from relay.felk.cvut.cz ([147.32.80.7]:49159 "EHLO
	relay.felk.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964871AbXCLDGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 23:06:20 -0400
X-Greylist: delayed 1891 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Mar 2007 23:06:20 EDT
From: Pavel Pisa <ppisa4lists@pikron.com>
Organization: PiKRON Ltd.
To: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: i.MX/MX1 SDHC fix/workaround of SD card recognition problems
Date: Mon, 12 Mar 2007 03:33:27 +0100
User-Agent: KMail/1.9.4
References: <200703080000.41101.ppisa@pikron.com> <45F49297.9090309@drzeus.cx>
In-Reply-To: <45F49297.9090309@drzeus.cx>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703120333.27581.ppisa4lists@pikron.com>
X-FELK-MailScanner-Information: 
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-2.54, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_20 -0.74)
X-FELK-MailScanner-From: ppisa4lists@pikron.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007 00:36, you wrote:
> Pavel Pisa wrote:
> > The SDHC controllers cannot process shorter transfers.
> > They has to be handled as longer ones, but it such case CRC
> > error is evaluated. There was a case in the code still,
> > where this error is not ignored as it should to be process
> > these transfers.
> >
> > Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
>
> Thanks, applied. Is this something critical that should be in 2.6.21?
>
> Rgds

Hello Pierre,

this should go to 2.6.21, I have hold this for some
months and I have discussed it in the thread
"Re: CRC Errors with SD cards in 4bits mode (on i.MXl)"
You have been CCed. This is not solution for seen data CRC
problem, but solves problems with recognition of cards
which has been timing sensitive sometimes.

I have sent it into Russell's patch queue with my others
MX1 fixes I have intended to be included in 2.6.21.
It was probably mistake for this one, because it should
go through your tree. If you send it to mainline
yourself, I would discard patch from patch daemon.

We have spoken about MX1 SDHC maintainership.
I am attaching my subscription.
I am not sure about mailing list field there.
Do you suggest this one, ALKML or other?

Best wishes

              Pavel Pisa

--------------------------------------------------------------
Subject: i.MX/MX1 SDHC maintainer

I am reporting to responsibility for i.MX MMC driver
bugs and coordination of the fighting against problems
of this hardware beast.

Signed-off-by: Pavel Pisa <ppisa@pikron.com>

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6.21-rc1/MAINTAINERS
===================================================================
--- linux-2.6.21-rc1.orig/MAINTAINERS
+++ linux-2.6.21-rc1/MAINTAINERS
@@ -1713,6 +1713,13 @@ M:	lethal@chaoticdreams.org
 L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 
+IMX MMC/SD HOST CONTROLLER INTERFACE DRIVER
+P:	Pavel Pisa
+M:	ppisa@pikron.com
+L:	sdhci-devel@list.drzeus.cx
+W:	http://mmc.drzeus.cx/wiki/Controllers/Freescale/SDHC
+S:	Maintained
+
 INFINIBAND SUBSYSTEM
 P:	Roland Dreier
 M:	rolandd@cisco.com
