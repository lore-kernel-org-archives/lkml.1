Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbXJXEIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbXJXEIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 00:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbXJXEIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 00:08:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54220
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751044AbXJXEIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 00:08:02 -0400
Date: Tue, 23 Oct 2007 21:07:47 -0700 (PDT)
Message-Id: <20071023.210747.102577114.davem@davemloft.net>
To: chuck.lever@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] NET: Treat the sign of the result of
 skb_headroom() consistently
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071023154423.28115.88775.stgit@ingres.1015granger.net>
References: <20071023154423.28115.88775.stgit@ingres.1015granger.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>
Date: Tue, 23 Oct 2007 11:44:23 -0400

> In some places, the result of skb_headroom() is compared to an unsigned
> integer, and in others, the result is compared to a signed integer.  Make
> the comparisons consistent and correct.
> 
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

This looks good, applied.

Thanks!
