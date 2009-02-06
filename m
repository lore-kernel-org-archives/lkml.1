Return-Path: <linux-kernel-owner+w=401wt.eu-S1757377AbZBFSFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbZBFSFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:05:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbZBFSFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:05:24 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:3144 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752431AbZBFSFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:05:23 -0500
Date: Fri, 6 Feb 2009 21:05:20 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH RFC 0/11] FSL eSDHC support: second call for comments
Message-ID: <20090206180520.GA16123@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

There were only a few comments on the previous version. So, here is
the second call for comments.

Changes since the first RFC:

- Use of_iomap() in sdhci-of.c (suggested by Arnd Bergmann). Also added
  Arnd's Acked-by: line for the sdhci-of patch.
- Kconfig help text improved (thanks to Matt Sealey and M. Warner Losh).
- In "sdhci: Add quirk to suppress PIO interrupts during DMA transfers"
  patch: sdhci_init() now clears SDHCI_PIO_DISABLED flag, otherwise we
  won't disable PIO interrupts after suspend.
- New patch: "sdhci: Add type checking for IO memory accessors"

That's all, for now.


Pierre, what do you think about memory accessors, what is your
preference regarding mem ops? Some options were discussed here:
http://lkml.org/lkml/2009/1/22/261


Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
