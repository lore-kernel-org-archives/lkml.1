Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab0CDIja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 03:39:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36132
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751469Ab0CDIj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 03:39:28 -0500
Date: Thu, 04 Mar 2010 00:39:46 -0800 (PST)
Message-Id: <20100304.003946.228300497.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com, wenxiong@us.ibm.com
Subject: Re: [PATCH] cxgb3: fix hot plug removal crash
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100303194947.31628.5933.stgit@speedy5.asicdesigners.com>
References: <20100303194947.31628.5933.stgit@speedy5.asicdesigners.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Wed, 03 Mar 2010 11:49:47 -0800

> From: Divy Le Ray <divy@chelsio.com>
> 
> queue restart tasklets need to be stopped after napi handlers are stopped
> since the latter can restart them.  So stop them after stopping napi.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
