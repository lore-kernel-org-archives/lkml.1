Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbXCSJcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbXCSJcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 05:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbXCSJcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 05:32:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:59392 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbXCSJce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 05:32:34 -0400
Date: Mon, 19 Mar 2007 11:33:15 +0200
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       "Eric W. Biederman" <ebiederman@lnxi.com>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: dst_ifdown breaks infiniband?
Message-ID: <20070319093315.GA15909@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <20070318155532.GG7958@mellanox.co.il>
	<20070318191238.GA20518@ms2.inr.ac.ru>
	<20070318202559.GD11078@mellanox.co.il>
	<m3tzwi8a20.fsf@maxwell.lnxi.com>
	<20070318223653.GO11078@mellanox.co.il>
	<20070318224234.GP11078@mellanox.co.il>
	<20070319092422.GB9387@ms2.inr.ac.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070319092422.GB9387@ms2.inr.ac.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>:
> Subject: Re: [ofa-general] Re: dst_ifdown breaks infiniband?
> 
> > Does this look sane (untested)?
> 
> It does not, unfortunately.
> 
> Instead of regular crash in infiniband you will get numerous
> random NULL pointer dereferences both due to dst->neighbour
> and due to dst->dev.

Right, I saw this clearly in the morning. Thanks.

-- 
MST
