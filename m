Return-Path: <linux-kernel-owner+w=401wt.eu-S934001AbXHVXgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934001AbXHVXgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 19:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763324AbXHVXgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 19:36:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:23273 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762786AbXHVXgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 19:36:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ET2/c2RKp7FuecyCEBgk/JLdtquw73MttwdOpKk62zingYe317oZ0CDDkcgW1PaUC2J1p9hFJwINWodaQQ0Vy8QoJA07BDnCl/qTIC2RtDQ7mlNAS0OwYVA6UU1mfriRmsa/vZFAQcb3OX2yLhdY+T7ACDxusFWguLGe/kSeofc=
Message-ID: <46CCC811.6050601@googlemail.com>
Date: Thu, 23 Aug 2007 01:34:41 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com, xfs@oss.sgi.com
Subject: fs/xfs/xfs_bmap_btree.c - compile error  (Re: 2.6.23-rc3-mm1)
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


config : http://194.231.229.228/kernel/mm/2.6.23-rc3-mm1/r/randconfig-18

...

fs/xfs/xfs_bmap_btree.c: In function 'xfs_bmbt_set_allf':
fs/xfs/xfs_bmap_btree.c:2312: error: 'b' undeclared (first use in this function)
fs/xfs/xfs_bmap_btree.c:2312: error: (Each undeclared identifier is reported only once
fs/xfs/xfs_bmap_btree.c:2312: error: for each function it appears in.)
fs/xfs/xfs_bmap_btree.c: In function 'xfs_bmbt_disk_set_allf':
fs/xfs/xfs_bmap_btree.c:2372: error: 'b' undeclared (first use in this function)
make[2]: *** [fs/xfs/xfs_bmap_btree.o] Error 1
make[2]: *** Waiting for unfinished jobs....
  CC      fs/reiser4/safe_link.o
  CC      fs/reiser4/plugin/plugin.o
make[1]: *** [fs/xfs] Error 2
make[1]: *** Waiting for unfinished jobs....

...
