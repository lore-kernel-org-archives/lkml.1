Return-Path: <linux-kernel-owner+w=401wt.eu-S1760866AbZBEAdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760866AbZBEAdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758283AbZBEAcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:32:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33986
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754383AbZBEAcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:32:54 -0500
Date: Wed, 04 Feb 2009 16:32:50 -0800 (PST)
Message-Id: <20090204.163250.127196315.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com, kxie@chelsio.com
Subject: Re: [PATCH 2.6.29] cxgb3 - Fix lro switch
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090205002547.26126.47373.stgit@speedy5>
References: <20090205002547.26126.47373.stgit@speedy5>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Wed, 04 Feb 2009 16:25:47 -0800

> The LRO switch is always set to 1 in the rx processing loop.
> It breaks the accelerated iSCSI receive traffic.
> Fix its computation.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied, thank you.

Could you slightly reformat your Subject lines for patches?  Please
use something like "cxgb3: $(description)" instead of the "cxgb3 -
$(description)" you're using now.

It'll be one less thing I need to edit when applying your
patches :-)

Thanks!
