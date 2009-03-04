Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbZCDFOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbZCDFOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 00:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbZCDFOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 00:14:15 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:50190 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbZCDFOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 00:14:15 -0500
Message-ID: <49AE0E13.6090905@oracle.com>
Date: Tue, 03 Mar 2009 21:13:55 -0800
From: Andy Grover <andy.grover@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] RDS: fix iband RDMA dependencies
References: <200903040054.n240sjQb023953@imap1.linux-foundation.org> <49ADF648.7090406@oracle.com>
In-Reply-To: <49ADF648.7090406@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.49AE0E17.0028:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Randy.

Acked-by: Andy Grover <andy.grover@oracle.com>

-- Andy

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix RDS Infiniband dependencies for RDMA so that these
> build errors won't happen:
> 
> ERROR: "rdma_accept" [net/rds/rds.ko] undefined!
> ERROR: "rdma_destroy_id" [net/rds/rds.ko] undefined!
> ERROR: "rdma_connect" [net/rds/rds.ko] undefined!
> ERROR: "rdma_destroy_qp" [net/rds/rds.ko] undefined!
> ERROR: "rdma_listen" [net/rds/rds.ko] undefined!
> ERROR: "rdma_notify" [net/rds/rds.ko] undefined!
> ERROR: "rdma_create_id" [net/rds/rds.ko] undefined!
> ERROR: "rdma_create_qp" [net/rds/rds.ko] undefined!
> ERROR: "rdma_bind_addr" [net/rds/rds.ko] undefined!
> ERROR: "rdma_resolve_route" [net/rds/rds.ko] undefined!
> ERROR: "rdma_disconnect" [net/rds/rds.ko] undefined!
> ERROR: "rdma_reject" [net/rds/rds.ko] undefined!
> ERROR: "rdma_resolve_addr" [net/rds/rds.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  net/rds/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- mmotm-2009-0303-1654.orig/net/rds/Kconfig
> +++ mmotm-2009-0303-1654/net/rds/Kconfig
> @@ -2,6 +2,7 @@
>  config RDS
>  	tristate "Reliable Datagram Sockets (RDS) (EXPERIMENTAL)"
>  	depends on INET && INFINIBAND_IPOIB && EXPERIMENTAL
> +	depends on INFINIBAND && INFINIBAND_ADDR_TRANS
>  	---help---
>  	  RDS provides reliable, sequenced delivery of datagrams
>  	  over Infiniband.
