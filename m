Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752318AbYLRBlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbYLRBlU (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 20:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbYLRBlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 20:41:02 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35326
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750817AbYLRBlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 20:41:00 -0500
Date: Wed, 17 Dec 2008 17:41:02 -0800 (PST)
Message-Id: <20081217.174102.121955000.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: gorcunov@gmail.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, xemul@openvz.org
Subject: Re: [PATCH] net: ppp_generic - use idr technique instead of
 cardmaps
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081217171625.776d4e46.akpm@linux-foundation.org>
References: <20081216192000.GF26390@localhost>
	<20081217171625.776d4e46.akpm@linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 17 Dec 2008 17:16:25 -0800

> What is the locking for the IDR tree?  all_ppp_mutex?

Yes.
