Return-Path: <linux-kernel-owner+w=401wt.eu-S1761443AbZENRH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761443AbZENRH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 13:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbZENRHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 13:07:43 -0400
Received: from h155.mvista.com ([63.81.120.155]:9128 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757895AbZENRHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 13:07:41 -0400
Message-ID: <4A0C5004.9040904@ru.mvista.com>
Date: Thu, 14 May 2009 21:08:20 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] ide: remove chipset field from hw_regs_t
References: <20090513205139.28638.87226.sendpatchset@localhost.localdomain> <20090513205215.28638.80164.sendpatchset@localhost.localdomain>
In-Reply-To: <20090513205215.28638.80164.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Convert host drivers that still use hw_regs_t's chipset field to use
>   the one in struct ide_port_info instead.

> * Move special handling of ide_pci chipset type from ide_hw_configure()
>   to ide_init_port().

> * Remove chipset field from hw_regs_t.

> While at it:
> - remove stale comment in delkin_cb.c

> There should be no functional changes caused by this patch.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
