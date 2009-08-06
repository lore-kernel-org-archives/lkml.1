Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbZHFDag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbZHFDag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 23:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbZHFDaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 23:30:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54492
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753836AbZHFDae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 23:30:34 -0400
Date: Wed, 05 Aug 2009 20:30:43 -0700 (PDT)
Message-Id: <20090805.203043.70203213.davem@davemloft.net>
To: julia@diku.dk
Cc: andy.grover@oracle.com, netdev@vger.kernel.org, rds-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] net/rds: Use AF_INET for sin_family field
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0908051434110.20453@pc-004.diku.dk>
References: <Pine.LNX.4.64.0908051434110.20453@pc-004.diku.dk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Wed, 5 Aug 2009 14:34:34 +0200 (CEST)

> Elsewhere the sin_family field holds a value with a name of the form
> AF_..., so it seems reasonable to do so here as well.  Also the values of
> PF_INET and AF_INET are the same.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
 ..
> Signed-off-by: Julia Lawall <julia@diku.dk>

This is obvious enough that I've just tossed it into net-next-2.6

Thanks!
