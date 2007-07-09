Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbXGISkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbXGISkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 14:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbXGISk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 14:40:27 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:55857 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752739AbXGISk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 14:40:26 -0400
Date: Mon, 9 Jul 2007 20:40:58 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Michael Chan <mchan@broadcom.com>, "David S. Miller" <davem@davemloft.net>,
       jgarzik@pobox.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: firmware in drivers/net/bnx2_fw{,2}.h
Message-ID: <20070709184058.GI3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

$ filterdiff -z -i \*bnx2_fw\* patch-2.6.22.gz | diffstat -p1 -w72
 drivers/net/bnx2_fw.h  | 1697 +++++---
 drivers/net/bnx2_fw2.h | 7868 ++++++++++++++++++++---------------------
 2 files changed, 4982 insertions(+), 4583 deletions(-)
$ 

Please switch this driver to use request_firmware().

TIA
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

