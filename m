Return-Path: <linux-kernel-owner+w=401wt.eu-S1758710AbXKNWOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710AbXKNWOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 17:14:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbXKNWNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 17:13:51 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:42709 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752720AbXKNWNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 17:13:50 -0500
Date: Wed, 14 Nov 2007 23:11:19 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Rainer Jochem <rainer.jochem@mpi-sb.mpg.de>
Cc: Patrick McHardy <kaber@trash.net>, davem@davemloft.net,
       kuznet@ms2.inr.ac.ru, jmorris@namei.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, pcernko@mpi-sws.mpg.de
Subject: Re: [PATCH] ipconfig.c : implement DHCP Class-identifier
Message-ID: <20071114221119.GA20108@electric-eye.fr.zoreil.com>
References: <20071108143205.GA22490@mpi-sb.mpg.de> <47332F1F.5040401@trash.net> <20071114084420.GA29241@mpi-sb.mpg.de> <473AB82F.8050801@trash.net> <20071114094508.GA6004@mpi-sb.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114094508.GA6004@mpi-sb.mpg.de>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rainer Jochem <rainer.jochem@mpi-sb.mpg.de> :
[...]
> --- net/ipv4/ipconfig.c.orig	2007-11-14 09:16:15.800566536 +0100
> +++ net/ipv4/ipconfig.c	2007-11-14 10:34:22.471219274 +0100
> @@ -139,6 +139,8 @@ __be32 ic_servaddr = NONE;	/* Boot serve
>  __be32 root_server_addr = NONE;	/* Address of NFS server */
>  u8 root_server_path[256] = { 0, };	/* Path to mount as root */
>  
> +static char vendor_class_identifier[253]; /* vendor class identifier */
> +

ic_dhcp_init_options is __init. Should it not be __initdata ?

-- 
Ueimor
