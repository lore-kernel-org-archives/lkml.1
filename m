Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbXJCC4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbXJCC4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 22:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbXJCC4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 22:56:47 -0400
Received: from zakalwe.fi ([80.83.5.154]:56721 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935AbXJCC4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 22:56:47 -0400
Date: Wed, 3 Oct 2007 05:56:45 +0300
From: Heikki Orsila <shdl@zakalwe.fi>
To: akepner@sgi.com
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       RolandDreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] mthca: allow setting "dmabarrier" on user-allocated memory
Message-ID: <20071003025645.GM3400@zakalwe.fi>
References: <20071003025007.GJ26752@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20071003025007.GJ26752@sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 07:50:07PM -0700, akepner@sgi.com wrote:
> +struct mthca_reg_mr {
> +	__u32 mr_attrs;
> +#define MTHCA_MR_DMAFLUSH 0x1	/* flush in-flight DMA on a write to 
> +				 * memory region */
> +	__u32 reserved;
> +};

Seems like a very odd place to #define something new..

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
