Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616AbYJXBFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbYJXBFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 21:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYJXBEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 21:04:51 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:10167 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbYJXBEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 21:04:50 -0400
Date: Thu, 23 Oct 2008 18:04:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, ericvh@gmail.com,
       rolandd@cisco.com
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       v9fs-developer@lists.sourceforge.net, general@lists.openfabrics.org
Subject: Re: linux-next: Tree for October 23
Message-Id: <20081023180412.394d40c2.randy.dunlap@oracle.com>
In-Reply-To: <20081023213637.eff9b414.sfr@canb.auug.org.au>
References: <20081023213637.eff9b414.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008 21:36:37 +1100 Stephen Rothwell wrote:

> Hi all,

Building with CONFIG_INFINIBAND=m, kconfig allows CONFIG_NET_9P_RDMA=m,
so one module wants symbols from the other (net/9p wants symbols from rmda_*).

ERROR: "rdma_destroy_id" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_connect" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_create_id" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_create_qp" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_resolve_route" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_disconnect" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_resolve_addr" [net/9p/9pnet_rdma.ko] undefined!

Is this supposed to be allowed/possible?  Otherwise NET_9P_RDMA might
have to depend on INFINBAND=y...

---
~Randy
