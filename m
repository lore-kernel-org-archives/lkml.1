Return-Path: <linux-kernel-owner+w=401wt.eu-S933036AbXCRTp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036AbXCRTp7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 15:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933044AbXCRTp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 15:45:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:45804 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933043AbXCRTp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 15:45:58 -0400
Date: Sun, 18 Mar 2007 21:46:38 +0200
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, general@lists.openfabrics.org,
       Roland Dreier <rolandd@cisco.com>
Subject: Re: dst_ifdown breaks infiniband?
Message-ID: <20070318194638.GA11078@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <20070318155532.GG7958@mellanox.co.il>
	<20070318191238.GA20518@ms2.inr.ac.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070318191238.GA20518@ms2.inr.ac.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>:
> Subject: Re: dst_ifdown breaks infiniband?
> 
> Hello!
> 
> > This is not new code, and should have triggered long time ago,
> > so I am not sure how come we are triggering this only now,
> > but somehow this did not lead to crashes in 2.6.20
> 
> I see. I guess this was plain luck.

Hmm. Something I don't understand: does the code
in question not run on *each* device unregister?

Why do I only see this under stress?

-- 
MST
