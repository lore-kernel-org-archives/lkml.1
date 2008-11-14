Return-Path: <linux-kernel-owner+w=401wt.eu-S1752077AbYKNO14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbYKNO14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 09:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbYKNO1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 09:27:47 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:52227 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbYKNO1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 09:27:47 -0500
Date: Fri, 14 Nov 2008 23:27:42 +0900 (JST)
Message-Id: <20081114.232742.128619046.anemo@mba.ocn.ne.jp>
To: vapier@gentoo.org
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mtd: unify mtd partition/device registration
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <1226665351-20226-1-git-send-email-vapier@gentoo.org>
References: <1226665351-20226-1-git-send-email-vapier@gentoo.org>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008 07:22:31 -0500, Mike Frysinger <vapier@gentoo.org> wrote:
> Rather than having every map/mtd driver doing the same sequence of
> registering partitions and/or devices, implement common parse_mtd().
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> v2:
> 	- ifdef parsers in parse_mtd()
> 	- add "always_whole" to parse_mtd()
> 	- add unparse_mtd()
> 
>  drivers/mtd/mtdcore.c   |   60 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mtd/mtd.h |    5 ++++
>  2 files changed, 65 insertions(+), 0 deletions(-)

Though not tested yet on real hardware, all patches looks OK for me.
Thanks!

---
Atsushi Nemoto
