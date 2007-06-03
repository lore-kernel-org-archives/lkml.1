Return-Path: <linux-kernel-owner+w=401wt.eu-S1760904AbXFCLvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904AbXFCLvS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 07:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757979AbXFCLvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 07:51:09 -0400
Received: from imx9.toshiba.co.jp ([202.33.96.51]:46948 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757833AbXFCLvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 07:51:08 -0400
Date: Sun, 03 Jun 2007 20:46:56 +0900 (JST)
Message-Id: <200706031146.l53Bku3q011948@toshiba.co.jp>
To: jengelh@linux01.gwdg.de
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] xt_connlimit (kernel) - connection limiting
From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <Pine.LNX.4.61.0706031312450.10578@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706031248290.10578@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706031312450.10578@yvahk01.tjqt.qr>
X-Mailer: Mew version 5.1 on Emacs 20.7 / Mule 4.0 (HANANOEN)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Date: Sun, 3 Jun 2007 13:12:55 +0200 (MEST)

> +static int __init xt_connlimit_init(void)
> +{
> +	need_conntrack_ipv4();
> +	return xt_register_match(&xt_connlimit_reg);
> +}

You can use nf_ct_l3proto_try_module_get() instead of introducing
need_conntrack_ipv4(). Please refer xt_state.c and xt_conntrack.c as
example.

-- Yasuyuki Kozakai
