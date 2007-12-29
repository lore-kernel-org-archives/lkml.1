Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970AbXL2Nn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbXL2Nn3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 08:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbXL2NnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 08:43:19 -0500
Received: from h155.mvista.com ([63.81.120.155]:11992 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753391AbXL2NnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 08:43:18 -0500
Message-ID: <47764F12.9080900@ru.mvista.com>
Date: Sat, 29 Dec 2007 16:43:46 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] ide: use ide_destroy_dmatable() instead of pci_unmap_sg()
References: <20071227191153.1357.63211.sendpatchset@localhost.localdomain> <20071227191223.1357.78845.sendpatchset@localhost.localdomain>
In-Reply-To: <20071227191223.1357.78845.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Use ide_destroy_dmatable() in:
> * ide-dma.c::ide_build_dmatable()
> * sgiioc4.c::sgiioc4_build_dma_table()
> * pmac.c::pmac_ide_{build,destroy}_dmatable()

> There should be no functionality changes caused by this patch.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei

