Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYKMNvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYKMNvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 08:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbYKMNuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 08:50:55 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:54419 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbYKMNuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 08:50:55 -0500
Date: Thu, 13 Nov 2008 22:51:01 +0900 (JST)
Message-Id: <20081113.225101.14979944.anemo@mba.ocn.ne.jp>
To: vapier@gentoo.org
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd/physmap: use parse_mtd()
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <1226533189-8492-1-git-send-email-vapier@gentoo.org>
References: <1226533133-7405-1-git-send-email-vapier@gentoo.org>
	<1226533189-8492-1-git-send-email-vapier@gentoo.org>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 18:39:48 -0500, Mike Frysinger <vapier@gentoo.org> wrote:
> Call parse_mtd() to handle partition/device registration rather than doing
> it all ourself.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  drivers/mtd/maps/physmap.c |   21 +--------------------
>  1 files changed, 1 insertions(+), 20 deletions(-)

You should adjust physmap_flash_remove() too.

* remove kfree(info->parts)
* call del_mtd_partitions() or del_mtd_device()

Maybe del_parsed_mtd() or something is required?

---
Atsushi Nemoto
