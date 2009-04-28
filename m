Return-Path: <linux-kernel-owner+w=401wt.eu-S932616AbZD1P1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616AbZD1P1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762665AbZD1PXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:23:43 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:43853 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762674AbZD1PXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:23:42 -0400
Date: Tue, 28 Apr 2009 17:23:25 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-mips@linux-mips.org, dan.j.williams@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] txx9dmac: Fix clearing of CHAR register in 32-bit
	kernel
Message-ID: <20090428152325.GA17411@linux-mips.org>
References: <1240931475-31326-1-git-send-email-anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240931475-31326-1-git-send-email-anemo@mba.ocn.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 12:11:15AM +0900, Atsushi Nemoto wrote:

> The CHAR register is 64-bit width but 32-bit kernel uses its lower
> part only.  Be careful of initializing it.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> ---
> This patch is against linux-mips.org linux-queue tree.
> Please queue this or fold into "DMA: TXx9 Soc DMA Controller driver" patch.

Done.  Thanks!

  Ralf
