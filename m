Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYHJGrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYHJGrd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 02:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbYHJGrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 02:47:25 -0400
Received: from relay04.mail-hub.dodo.com.au ([123.2.6.239]:41921 "EHLO
	relay04.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752157AbYHJGrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 02:47:25 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Query: should 'Marvell SATA support' depend on PCI?
Date: Sun, 10 Aug 2008 16:47:09 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <vg3t941ebudmtb8afj82thuldug82ak1fs@4ax.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

I was reworking the ATA driver menu patch to shrink it (merge 'depends on' 
lines) and noticed that the:

config SATA_MV
        tristate "Marvell SATA support (HIGHLY EXPERIMENTAL)"
        depends on EXPERIMENTAL
        help
          This option enables support for the Marvell Serial ATA family.
          Currently supports 88SX[56]0[48][01] chips.

doesn't have 'depends on PCI && EXPERIMENTAL' like other drivers around 
it, this is okay or should it also depend on PCI?

Grant.
