Return-Path: <linux-kernel-owner+w=401wt.eu-S1750840AbZK0FFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750840AbZK0FFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 00:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750742AbZK0FFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 00:05:24 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:64977 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbZK0FFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 00:05:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=heL8ugle2ewyYrjXhpL8OmfHiPKzf+JPW8p9Wvo5OTnPy1+/+PISZTwZJHUbtU7zmj
         pGWbM5PxtcR4juUEawaQ4NYd8Elcscy5dDKNxjTwUP2dYOb8dmcCxhdTJG0gklO1FMi7
         cpja7hz56ErqoybvPzjuQJOxUMbEEZnZC/cqc=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ian@mnementh.co.uk, lethal@linux-sh.org,
       philipp.zabel@gmail.com, pierre@ossman.eu,
       Magnus Damm <magnus.damm@gmail.com>, akpm@linux-foundation.org
Date: Fri, 27 Nov 2009 13:59:56 +0900
Message-Id: <20091127045956.15251.84958.sendpatchset@rxone.opensource.se>
Subject: [PATCH 00/03] mmc: A few trivial changes for tmio-mmc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmc: A few trivial changes for tmio-mmc 

[PATCH 01/03] mmc: Let tmio-mmc use dev_name() with request_irq()
[PATCH 02/03] mmc: Remove const from tmio-mmc platform data V2
[PATCH 03/03] mmc: Balance tmio-mmc cell enable()/disable() calls

These patches contain a few trivial changes for the tmio-mmc driver.
Nothing out of the ordinary. Tested together with the sh_mobile_sdhi
mfd driver on a sh7724 Ecovec board.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/mmc/host/tmio_mmc.c |   12 +++++++++---
 include/linux/mfd/tmio.h    |    2 +-
 2 files changed, 10 insertions(+), 4 deletions(-)
