Return-Path: <linux-kernel-owner+w=401wt.eu-S1761515AbZBMOqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761515AbZBMOqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761243AbZBMOqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:46:34 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:16686 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761063AbZBMOqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:46:33 -0500
Date: Fri, 13 Feb 2009 17:46:30 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH RFC 0/13] FSL eSDHC support
Message-ID: <20090213144630.GA13436@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Thanks for the comments on the previous version, here comes another
RFC...

Changes since the second RFC:
- Addressed all comments that were raised by Pierre Ossman.
  There were too many to mention them all, so here is the link:
  http://lkml.org/lkml/2009/2/6/320

Changes since the first RFC:
- Use of_iomap() in sdhci-of.c (suggested by Arnd Bergmann). Also added
  Arnd's Acked-by: line for the sdhci-of patch.
- Kconfig help text improved (thanks to Matt Sealey and M. Warner Losh).
- In "sdhci: Add quirk to suppress PIO interrupts during DMA transfers"
  patch: sdhci_init() now clears SDHCI_PIO_DISABLED flag, otherwise we
  won't disable PIO interrupts after suspend.
- New patch: "sdhci: Add type checking for IO memory accessors"

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
