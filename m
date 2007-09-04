Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbXIDMhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbXIDMhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 08:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbXIDMhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 08:37:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:46026 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbXIDMhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 08:37:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=hgaIi+GCygGCBaY18qBglIaEZJfzqqyEKFco0rnXkSOBI/Bv/4ckX/aCum7KTNTuW0RvRjodTGdOo+k9+2FHqRJxggt60V3x3pWRe/hPqFbKTxZpLGc9a5meRjDHc5aeqc6m9Zho+C44AWmJHoejhzPtLK6tcD0pR3Zb4JFOUsU=
Message-ID: <6278d2220709040537n4c96ffcagd9c25c94ddd29ca1@mail.gmail.com>
Date: Tue, 4 Sep 2007 13:37:22 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>, jgarzik@pobox.com
Subject: ICH Intel PATA short cable override...
Cc: linux-ide@vger.kernel.org, "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We see that in ata_piix.c, there is a whitelist for (laptop) Intel ICH
controllers with short cables, tied to specific vendor subsystem IDs.
Since my mini-ITX Ibase MI910F has the subsystem IDs specified as
Intel [1], this is unusable.

I can't find another existing mechanism to add short cable
information, to allow UDMA/66 for my on-board CF socket.

Do you suggest I cook a patch to pass a kernel argument eg 'ich=short'
or 'pata=short', or can you think of a better mechanism?

Thanks,
  Daniel

--- [1]

# lspci -vs 00:1f.2
00:1f.2 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E)
SATA IDE Controller (rev 03) (prog-if 80 [Master])
        Subsystem: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA
IDE Controller

# lspci -vns 00:1f.2
00:1f.2 0101: 8086:2828 (rev 03) (prog-if 80 [Master])
        Subsystem: 8086:2828
-- 
Daniel J Blueman
