Return-Path: <linux-kernel-owner+w=401wt.eu-S1757602AbYGCMNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbYGCMNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756039AbYGCMM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:12:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43982
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756032AbYGCMMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:12:24 -0400
Date: Thu, 03 Jul 2008 03:22:32 -0700 (PDT)
Message-Id: <20080703.032232.103611092.davem@davemloft.net>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: + net-ipv4-tcpc-needs-linux-scatterlisth.patch added to -mm
 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <200807030317.m633H5Ys017057@imap1.linux-foundation.org>
References: <200807030317.m633H5Ys017057@imap1.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: akpm@linux-foundation.org
Date: Wed, 02 Jul 2008 20:04:57 -0700

> Subject: net/ipv4/tcp.c needs linux/scatterlist.h
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> alpha:
> 
> net/ipv4/tcp.c: In function 'tcp_calc_md5_hash':
> net/ipv4/tcp.c:2479: error: implicit declaration of function 'sg_init_table'    net/ipv4/tcp.c:2482: error: implicit declaration of function 'sg_set_buf'
> net/ipv4/tcp.c:2507: error: implicit declaration of function 'sg_mark_end'      
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Applied to net-2.6, thanks Andrew.
