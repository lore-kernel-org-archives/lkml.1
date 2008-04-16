Return-Path: <linux-kernel-owner+w=401wt.eu-S1763156AbYDPRg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763156AbYDPRg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 13:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbYDPRgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 13:36:18 -0400
Received: from h155.mvista.com ([63.81.120.155]:34254 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750879AbYDPRgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 13:36:17 -0400
Message-ID: <480638EA.2000708@ru.mvista.com>
Date: Wed, 16 Apr 2008 21:35:38 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] scc_pata: add ->{in,out}put_data methods
References: <200803302141.06106.bzolnier@gmail.com>
In-Reply-To: <200803302141.06106.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> There should be no functional changes caused by this patch.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

> Index: b/drivers/ide/pci/scc_pata.c
> ===================================================================
> --- a/drivers/ide/pci/scc_pata.c
> +++ b/drivers/ide/pci/scc_pata.c
> @@ -574,6 +574,36 @@ static int __devinit init_setup_scc(stru
>  	return ide_setup_pci_device(dev, d);
>  }

    This patch in the pata-2.6 series doesn't apply anymore after the patch 
getting rid of ide_setup_pci_device() call was merged.

WBR, Sergei
