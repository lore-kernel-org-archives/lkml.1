Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbZBMNoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbZBMNoM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 08:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbZBMNno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 08:43:44 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:41548 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbZBMNnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 08:43:42 -0500
Date: Fri, 13 Feb 2009 14:43:36 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: "Sachin P. Sant" <sachinp@in.ibm.com>
Cc: schwidefsky@de.ibm.com, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-s390@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Subject: Re: [Patch] [S390]  Fix appldata build break with !NET
Message-ID: <20090213144336.69a45d32@osiris.boeblingen.de.ibm.com>
In-Reply-To: <49955945.2080809@in.ibm.com>
References: <20090213175526.d0590862.sfr@canb.auug.org.au>
	<49954589.9060604@in.ibm.com>
	<49955945.2080809@in.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Feb 2009 16:58:05 +0530
"Sachin P. Sant" <sachinp@in.ibm.com> wrote:

> With CONFIG_NET not set appldata build breaks on s390.
> 
> arch/s390/appldata/built-in.o: In function appldata_get_net_sum_data:
> appldata_net_sum.c:(.text+0x2684): undefined reference to dev_get_stats
> appldata_net_sum.c:(.text+0x2688): undefined reference to init_net
> appldata_net_sum.c:(.text+0x268c): undefined reference to init_net
> appldata_net_sum.c:(.text+0x2694): undefined reference to dev_base_lock
> 
> The following patch fixes the issue for me.

Added to our patch queue. Thanks, Sachin!
