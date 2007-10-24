Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbXJXEJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbXJXEJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 00:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbXJXEJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 00:09:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35607
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750733AbXJXEJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 00:09:31 -0400
Date: Tue, 23 Oct 2007 21:09:15 -0700 (PDT)
Message-Id: <20071023.210915.88476472.davem@davemloft.net>
To: chuck.lever@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] NET: Remove unneeded implicit type case when
 calling tcp_minshall_update()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071023154433.28115.72800.stgit@ingres.1015granger.net>
References: <20071023154433.28115.72800.stgit@ingres.1015granger.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>
Date: Tue, 23 Oct 2007 11:44:33 -0400

> The tcp_minshall_update() function is called in exactly one place, and is
> passed an unsigned integer for the mss_len argument.  Make the sign of the
> argument match the sign of the passed variable in order to eliminate an
> unneeded implicit type cast and a mixed sign comparison in
> tcp_minshall_update().
> 
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

Applied, thanks.

> Cc: <netdev@vger.kernel.org>

Actually, you only CC:'d linux-kernel on these patches.
