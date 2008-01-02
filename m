Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbYABDb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbYABDb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 22:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbYABDbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 22:31:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57025
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756674AbYABDbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 22:31:13 -0500
Date: Tue, 01 Jan 2008 19:31:12 -0800 (PST)
Message-Id: <20080101.193112.20706369.davem@davemloft.net>
To: julia@diku.dk
Cc: eis@baty.hanse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net/x25: Add missing x25_neigh_put
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0801012206090.19803@ask.diku.dk>
References: <Pine.LNX.4.64.0801012206090.19803@ask.diku.dk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Tue, 1 Jan 2008 22:07:04 +0100 (CET)

> The function x25_get_neigh increments a reference count.  At the point of
> the second goto out, the result of calling x25_get_neigh is only stored in
> a local variable, and thus no one outside the function will be able to
> decrease the reference count.  Thus, x25_neigh_put should be called before
> the return in this case.

Patch applied, thanks.
