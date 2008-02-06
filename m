Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbYBFEAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbYBFEAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 23:00:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757256AbYBFD7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 22:59:54 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55335
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757157AbYBFD7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 22:59:53 -0500
Date: Tue, 05 Feb 2008 20:00:22 -0800 (PST)
Message-Id: <20080205.200022.79543549.davem@davemloft.net>
To: horms@verge.net.au
Cc: sven.wegener@stealer.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: Make wrr "no available servers" error message
 rate-limited
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080206021909.GA32678@verge.net.au>
References: <1202243421-2774-1-git-send-email-sven.wegener@stealer.net>
	<20080206021909.GA32678@verge.net.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Horman <horms@verge.net.au>
Date: Wed, 6 Feb 2008 11:19:09 +0900

> On Tue, Feb 05, 2008 at 09:30:21PM +0100, Sven Wegener wrote:
> > No available servers is more an error message than something informational. It
> > should also be rate-limited, else we're going to flood our logs on a busy
> > director, if all real servers are out of order with a weight of zero.
> > 
> > Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
> 
> Hi Sven,
> 
> this looks good to me.
> 
> Acked-by: Simon Horman <horms@verge.net.au>

Applied, thanks.
