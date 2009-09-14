Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbZINOzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbZINOzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 10:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbZINOzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 10:55:38 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:57905 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbZINOzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 10:55:38 -0400
Date: Mon, 14 Sep 2009 16:56:18 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Julia Lawall <julia@diku.dk>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/8] arch/mips/txx9: introduce missing kfree, iounmap
Message-ID: <20090914145618.GB1934@linux-mips.org>
References: <Pine.LNX.4.64.0909111820370.10552@pc-004.diku.dk> <20090913.232548.253168283.anemo@mba.ocn.ne.jp> <Pine.LNX.4.64.0909131708190.25903@ask.diku.dk> <20090914.003321.160496287.anemo@mba.ocn.ne.jp> <Pine.LNX.4.64.0909132113520.31000@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0909132113520.31000@ask.diku.dk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 13, 2009 at 09:15:18PM +0200, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> Error handling code following a kzalloc should free the allocated data.
> Error handling code following an ioremap should iounmap the allocated data.
> 
> The semantic match that finds the first problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)

Guess this one looks right, applied.

Thanks,

  Ralf
