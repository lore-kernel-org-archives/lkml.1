Return-Path: <linux-kernel-owner+w=401wt.eu-S1761957AbYFMKDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761957AbYFMKDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 06:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbYFMKD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 06:03:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41680
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755876AbYFMKD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 06:03:26 -0400
Date: Fri, 13 Jun 2008 03:03:26 -0700 (PDT)
Message-Id: <20080613.030326.60083578.davem@davemloft.net>
To: richard@rsk.demon.co.uk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Net: reorder udp_iter_state to remove padding on 64bit
 builds
From: David Miller <davem@davemloft.net>
In-Reply-To: <1212662019.3039.14.camel@castor.localdomain>
References: <1212662019.3039.14.camel@castor.localdomain>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Kennedy <richard@rsk.demon.co.uk>
Date: Thu, 05 Jun 2008 11:33:39 +0100

> reorder udp_iter_state to remove padding on 64bit builds
> 
> shrinks from 24 to 16 bytes, moving to a smaller slab when CONFIG_NET_NS
> is undefined & seq_net_private = {}
> 
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

Applied, th anks Richard.
