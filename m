Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbZBFJch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbZBFJch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 04:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZBFJcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 04:32:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59567
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753508AbZBFJcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 04:32:18 -0500
Date: Fri, 06 Feb 2009 01:32:14 -0800 (PST)
Message-Id: <20090206.013214.132906308.davem@davemloft.net>
To: yinghai@kernel.org
Cc: jeff@garzik.org, mingo@elte.hu, akpm@linux-foundation.org,
       aabdulla@nvidia.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] forcedeth: disable irq at first before schedule rx
From: David Miller <davem@davemloft.net>
In-Reply-To: <498BC412.3090900@kernel.org>
References: <498BC3A8.9040203@kernel.org>
	<498BC412.3090900@kernel.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>
Date: Thu, 05 Feb 2009 21:01:06 -0800

> 
> Impact: clean up
> 
> schedule it later after disable it.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Applied to net-next-2.6

I had to edit this patch to make it apply properly.  In net-next-2.6
the netix_rx_*() have been renamed to napi_*() and the former interfaces
deleted.

Please generate your patches properly against net-next-2.6 in the
future.

Thanks.
