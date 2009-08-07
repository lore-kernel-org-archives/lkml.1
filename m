Return-Path: <linux-kernel-owner+w=401wt.eu-S933308AbZHGT5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933308AbZHGT5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 15:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933264AbZHGT5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 15:57:25 -0400
Received: from ru.mvista.com ([213.79.90.228]:2219 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933261AbZHGT5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 15:57:24 -0400
Date: Fri, 7 Aug 2009 23:57:24 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pierre Ossman <pierre@ossman.eu>, Kumar Gala <galak@kernel.crashing.org>,
       David Vrabel <david.vrabel@csr.com>, Ben Dooks <ben@fluff.org>,
       Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
       sdhci-devel@lists.ossman.eu, linuxppc-dev@ozlabs.org
Subject: [PATCH v2 0/7] sdhci-of: Some fixes for high-speed and 4-bit SD
 cards
Message-ID: <20090807195724.GA24020@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In v2:

- Addressed David Vrabel's comments;
- New patches added:
  powerpc: Introduce and document sdhci,wp-inverted property for eSDHC
  sdhci-of: Don't hard-code inverted write-protect quirk
  powerpc/85xx: Add eSDHC support for MPC8536DS boards
