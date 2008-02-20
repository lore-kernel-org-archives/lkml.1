Return-Path: <linux-kernel-owner+w=401wt.eu-S1760948AbYBTF01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760948AbYBTF01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 00:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbYBTF0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 00:26:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45083
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751499AbYBTF0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 00:26:18 -0500
Date: Tue, 19 Feb 2008 21:26:55 -0800 (PST)
Message-Id: <20080219.212655.173468988.davem@davemloft.net>
To: galak@kernel.crashing.org
Cc: sparclinux@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [LMB]: Fix lmb_add_region if region should be added at
 the head
From: David Miller <davem@davemloft.net>
In-Reply-To: <7A7ECF09-E547-4C04-A388-C3E8755478DD@kernel.crashing.org>
References: <Pine.LNX.4.64.0802192227170.2215@blarg.am.freescale.net>
	<20080219.204525.193731674.davem@davemloft.net>
	<7A7ECF09-E547-4C04-A388-C3E8755478DD@kernel.crashing.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Gala <galak@kernel.crashing.org>
Date: Tue, 19 Feb 2008 23:16:18 -0600

> The for loop above the code I added will move all the existing slots  
> up one.  Its just the tail cleanup we are missing.

Aha, I see how this works now, thanks!

I'll add this to my LMB tree.
