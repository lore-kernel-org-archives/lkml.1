Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbYCIRAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbYCIRAS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbYCIRAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:00:04 -0400
Received: from h155.mvista.com ([63.81.120.155]:36188 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750997AbYCIRAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:00:03 -0400
Message-ID: <47D417DD.20404@ru.mvista.com>
Date: Sun, 09 Mar 2008 20:01:17 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ide: constify struct ide_dma_ops
References: <200803091702.18521.bzolnier@gmail.com>
In-Reply-To: <200803091702.18521.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> * Export ide_dma_exec_cmd() and __ide_dma_test_irq().

> * Constify struct ide_dma_ops.

> * Always set hwif->dma_ops to &sff_dma_ops in ide_setup_dma()
>   (it is later overriden by ide_init_port() if needed) and drop
>   'const struct ide_port_info *d' argument.

> While at it:

> * Rename __ide_dma_test_irq() to __ide_dma_test_irq().

    Huh? :-)

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

MBR, Sergei
