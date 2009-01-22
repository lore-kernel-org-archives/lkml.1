Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbZAVB5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbZAVB5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 20:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755218AbZAVB4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 20:56:51 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:44799 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754904AbZAVB4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 20:56:50 -0500
Date: Thu, 22 Jan 2009 04:56:49 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, Xie Xiaobo <X.Xie@freescale.com>,
       Konjin Lai <Konjin.Lai@freescale.com>,
       "Joe D'Abbraccio" <Joe.D'abbraccio@freescale.com>,
       sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH RFC 0/10] Freescale "eSDHC" SDHCI support (was [PATCH] mmc:
	Add driver for Freescale eSDHC controllers)
Message-ID: <20090122015649.GA6835@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 07:37:00AM +0800, Liu Dave wrote:
> > This patch adds support for the Freescale Enhanced Secure Digital
> > Host Controller Interface as found in some Freescale PowerPC
> > microprocessors (e.g. MPC837x SOCs).
> 
> The Freescale ESDHC controller is basically compatible with the
> standard SDHC controller. but the eshdc expand some bits.
> 
> The esdhc.c is much like the orignal sdhci.c.
> it is possible to merge them.

Seem to work indeed. Quite a lot of quirks needed though.

Patches on the way...

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
