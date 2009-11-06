Return-Path: <linux-kernel-owner+w=401wt.eu-S1759602AbZKFSRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbZKFSRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 13:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759592AbZKFSRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 13:17:23 -0500
Received: from fifo99.com ([67.223.236.141]:56692 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759552AbZKFSRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 13:17:21 -0500
Subject: Re: [PATCH 1/7] compat: add struct compat_ifreq etc to compat.h
From: Daniel Walker <dwalker@fifo99.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Christoph Hellwig <hch@lst.de>, netdev@vger.kernel.org
In-Reply-To: <1257530949-9695-2-git-send-email-arnd@arndb.de>
References: <1257530949-9695-1-git-send-email-arnd@arndb.de>
	 <1257530949-9695-2-git-send-email-arnd@arndb.de>
Content-Type: text/plain
Date: Fri, 06 Nov 2009 10:17:17 -0800
Message-Id: <1257531437.7630.2.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-06 at 19:09 +0100, Arnd Bergmann wrote:
> +struct compat_ifreq {
> +#define IFHWADDRLEN     6
> +#define IFNAMSIZ        16
> +        union {
> +                char    ifrn_name[IFNAMSIZ];            /* if name,
> e.g. "en0" */
> +        } ifr_ifrn;
> +        union {
> +                struct  sockaddr ifru_addr;
> +                struct  sockaddr ifru_dstaddr;
> +                struct  sockaddr ifru_broadaddr;
> +                struct  sockaddr ifru_netmask;
> +                struct  sockaddr ifru_hwaddr;
> +                short   ifru_flags;
> +                compat_int_t     ifru_ivalue;
> +                compat_int_t     ifru_mtu;
> +                struct  compat_ifmap ifru_map;
> +                char    ifru_slave[IFNAMSIZ];   /* Just fits the size
> */
> +               char    ifru_newname[IFNAMSIZ];
> +                compat_caddr_t ifru_data;
> +           /* XXXX? ifru_settings should be here */
> +        } ifr_ifru;
> +};
> +

Did you just copy this from someplace else? Many of the lines seems to
be tab damaged.

Daniel

