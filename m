Return-Path: <linux-kernel-owner+w=401wt.eu-S1758277AbYHUNLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbYHUNLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 09:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbYHUNLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 09:11:07 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:37729 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbYHUNLG (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 09:11:06 -0400
Subject: Re: [PATCH 03/10] AXFS: axfs.h
From: Daniel Walker <dwalker@mvista.com>
To: jaredeh@gmail.com
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>, tim.bird@AM.SONY.COM,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <48AD00E6.2070505@gmail.com>
References: <48AD00E6.2070505@gmail.com>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 06:10:58 -0700
Message-Id: <1219324258.23311.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-20 at 22:45 -0700, Jared Hulbert wrote:
> +#define AXFS_GET_BYTETABLE_VAL(desc,index) \
> +  axfs_bytetable_stitch(((struct
> axfs_region_desc)(desc)).table_byte_depth,\
> +  (u8 *)((struct axfs_region_desc)(desc)).virt_addr, index)
> +
> +#define AXFS_GET_NODE_TYPE(sbi,node_index) \
> +  AXFS_GET_BYTETABLE_VAL(((struct axfs_super *)(sbi))->node_type,\
> +   (node_index))
> +
> +#define AXFS_GET_NODE_INDEX(sbi,node__index) \
> +  AXFS_GET_BYTETABLE_VAL(((struct axfs_super *)(sbi))->node_index,\
> +   (node__index))
> +

I think it would be much cleaner to do all these similar macro's as
static inline functions.

Daniel

