Return-Path: <linux-kernel-owner+w=401wt.eu-S933092AbXCRUZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092AbXCRUZT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 16:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933140AbXCRUZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 16:25:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:16192 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933092AbXCRUZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 16:25:17 -0400
Date: Sun, 18 Mar 2007 22:25:59 +0200
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, general@lists.openfabrics.org,
       Roland Dreier <rolandd@cisco.com>
Subject: Re: dst_ifdown breaks infiniband?
Message-ID: <20070318202559.GD11078@mellanox.co.il>
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

> > Why is neighbour->dev changed here?
> 
> It holds reference to device and prevents its destruction.
> If dst is held somewhere, we cannot destroy the device and deadlock
> while unregister.

BTW, can this ever happen for the loopback device itself?
Is it ever unregistered?

-- 
MST
