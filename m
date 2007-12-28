Return-Path: <linux-kernel-owner+w=401wt.eu-S1752964AbXL1MPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbXL1MPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 07:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbXL1MPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 07:15:05 -0500
Received: from h155.mvista.com ([63.81.120.155]:7189 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752967AbXL1MPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 07:15:04 -0500
Message-ID: <4774E8E4.1080400@ru.mvista.com>
Date: Fri, 28 Dec 2007 15:15:32 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] ide: fix ide_intr() for non-PCI devices and CONFIG_BLK_DEV_IDEPCI=y
References: <20071227191153.1357.63211.sendpatchset@localhost.localdomain> <20071227191207.1357.24118.sendpatchset@localhost.localdomain>
In-Reply-To: <20071227191207.1357.24118.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> 'hwif->pci_dev && !hwif->pci_dev->vendor' condition is never true,
> check for 'hwif->chipset != ide_pci' instead.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
