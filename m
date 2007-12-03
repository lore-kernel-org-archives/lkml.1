Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbXLCOdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbXLCOdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 09:33:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750727AbXLCOc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 09:32:56 -0500
Received: from avexch2.qlogic.com ([198.70.193.116]:44639 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbXLCOcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 09:32:55 -0500
X-Greylist: delayed 892 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Dec 2007 09:32:55 EST
Message-ID: <47541019.70302@qlogic.com>
Date: Mon, 03 Dec 2007 06:18:01 -0800
From: Seokmann Ju <seokmann.ju@qlogic.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: linux-driver@qlogic.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] scsi/qla2xxx/qla_os.c section fix
References: <20071125220503.GF18284@stusta.de>
In-Reply-To: <20071125220503.GF18284@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Dec 2007 14:16:37.0784 (UTC) FILETIME=[1DF37180:01C835B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> qla2x00_remove_one() mustn't be __devexit since it's called from 
> qla2xxx_pci_error_detected().
> 
> This patch fixes the following section mismatch:
> 
> <--  snip  -->
> 
> ...
> WARNING: vmlinux.o(.text+0x2a4462): Section mismatch: reference to .exit.text:qla2x00_remove_one (between 'qla2xxx_pci_error_detected' and 'qla2x00_stop_timer')
> ...
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
ACK.
Acked-by: Seokmann Ju <seokmann.ju@qlogic.com>
