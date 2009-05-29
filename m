Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550AbZE2I5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbZE2I5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 04:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757611AbZE2I4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 04:56:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36756
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757528AbZE2I4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 04:56:52 -0400
Date: Fri, 29 May 2009 01:56:52 -0700 (PDT)
Message-Id: <20090529.015652.89167404.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.30 2/2] cxgb3: link fault fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090528212308.28184.39504.stgit@speedy5>
References: <20090528212308.28184.39504.stgit@speedy5>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Thu, 28 May 2009 14:23:08 -0700

> From: Divy Le Ray <divy@chelsio.com>
> 
> Do not call t3_link_fault() under spinlock, as it calls msleep().
> Besides, only the access to pi->link_fault needs to be serialized.
> 
> Also initialize local variables before checking the link status,
> link state fields might otherwise end up containing garbage.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
