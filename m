Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbZDTJIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbZDTJIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 05:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbZDTJIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 05:08:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59066
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752152AbZDTJIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 05:08:20 -0400
Date: Mon, 20 Apr 2009 02:08:11 -0700 (PDT)
Message-Id: <20090420.020811.133077999.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.30 1/4] cxgb3: fix link fault handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090417222111.8472.45439.stgit@speedy5>
References: <20090417222111.8472.45439.stgit@speedy5>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Fri, 17 Apr 2009 15:21:11 -0700

> Use the existing periodic task to handle link faults.
> The link fault interrupt handler is also called in work queue context,
> which is wrong and might cause potential deadlocks.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
