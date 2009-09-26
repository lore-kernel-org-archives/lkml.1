Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbZIZTXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbZIZTXK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 15:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbZIZTXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 15:23:08 -0400
Received: from fifo99.com ([67.223.236.141]:33960 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbZIZTXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 15:23:07 -0400
Subject: Re: [PATCH v3 net-next-2.6] cxgb3: Added private MAC address and
 provisioning packet handler for iSCSI
From: Daniel Walker <dwalker@fifo99.com>
To: kxie@chelsio.com
Cc: davem@davemloft.net, swise@opengridcomputing.com, divy@chelsio.com,
       rakesh@chelsio.com, michaelc@cs.wisc.edu,
       James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <200909261903.n8QJ3D2b000882@localhost.localdomain>
References: <200909261903.n8QJ3D2b000882@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 26 Sep 2009 12:22:39 -0700
Message-Id: <1253992959.20648.434.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-26 at 12:03 -0700, kxie@chelsio.com wrote:
>  enum {                 /* rx_offload flags */
>         T3_RX_CSUM      = 1 << 0,
>         T3_LRO          = 1 << 1,
>  };
>  
> +enum {
> +       LAN_MAC_IDX     = 0,
> +       SAN_MAC_IDX,
> +
> +       MAX_MAC_IDX
> +};

Why not name the enum and use it in the function declarations? I see
there are some other unnamed enums in there so you are following the
style in the file already.. However, naming the enum and using it allows
the input values to be known instead of just saying "int n", so I think
that's a better method..

Daniel



