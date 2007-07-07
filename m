Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbXGGSNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbXGGSNl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 14:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbXGGSNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 14:13:33 -0400
Received: from h155.mvista.com ([63.81.120.155]:56052 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752547AbXGGSNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 14:13:32 -0400
Message-ID: <468FD841.6070900@ru.mvista.com>
Date: Sat, 07 Jul 2007 22:15:29 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: linux-ide@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] [ide] mmio ide support
References: <20070707094852.9473.21013.stgit@localhost.localdomain>
In-Reply-To: <20070707094852.9473.21013.stgit@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Vitaly Bordug wrote:

> This adds support for MMIO IDE device like CompactFlash 
> in TrueIDE mode.

> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com> 
> Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>

[...]

> diff --git a/drivers/ide/legacy/mmio-ide.c b/drivers/ide/legacy/mmio-ide.c
> new file mode 100644
> index 0000000..77fb7dd
> --- /dev/null
> +++ b/drivers/ide/legacy/mmio-ide.c
[...]
> +	hwif->mmio = 2;

     That hwif->mmio is single-bit field now, so can only be 0 or 1.

MBR, Sergei
