Return-Path: <linux-kernel-owner+w=401wt.eu-S1757220AbYAHGJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbYAHGJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 01:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbYAHGJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 01:09:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38578
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755040AbYAHGJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 01:09:29 -0500
Date: Mon, 07 Jan 2008 22:09:28 -0800 (PST)
Message-Id: <20080107.220928.211341509.davem@davemloft.net>
To: Brice.Goglin@inria.fr
Cc: gallatin@myri.com, themann@de.ibm.com, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH][LRO] Fix lro_mgr->features checks
From: David Miller <davem@davemloft.net>
In-Reply-To: <47822A2C.4020303@inria.fr>
References: <47822A2C.4020303@inria.fr>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brice Goglin <Brice.Goglin@inria.fr>
Date: Mon, 07 Jan 2008 14:33:32 +0100

> [PATCH][LRO] Fix lro_mgr->features checks
> 
> lro_mgr->features contains a bitmask of LRO_F_* values which are
> defined as power of two, not as bit indexes.
> They must be checked with x&LRO_F_FOO, not with test_bit(LRO_F_FOO,&x).
> 
> Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
> Acked-by: Andrew Gallatin <gallatin@myri.com>

Applied, thanks a lot.
