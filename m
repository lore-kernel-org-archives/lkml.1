Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364Ab0AHIM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab0AHIM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 03:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337Ab0AHIMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 03:12:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50356
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752602Ab0AHIMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 03:12:54 -0500
Date: Fri, 08 Jan 2010 00:13:02 -0800 (PST)
Message-Id: <20100108.001302.146106973.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: jkosina@suse.cz, peterhuewe@gmx.de, kernel-janitors@vger.kernel.org,
       sshtylyov@ru.mvista.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ide: add __init/__exit macros to
 drivers/ide/scc_pata.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <201001051939.07756.bzolnier@gmail.com>
References: <1261470564-23754-2-git-send-email-peterhuewe@gmx.de>
	<alpine.LNX.2.00.1001051124150.2277@pobox.suse.cz>
	<201001051939.07756.bzolnier@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Tue, 5 Jan 2010 19:39:07 +0100

> -	ide_pci_unregister_driver(&scc_pci_driver);
> +	pci_unregister_driver(&scc_pci_driver);

As a side note I can't figure out how this driver can currently even
build without errors before this patch.

ide_pci_unregister_driver() isn't even defined anywhere these days.
