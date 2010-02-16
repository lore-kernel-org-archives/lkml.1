Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab0BPFwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 00:52:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41344
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751807Ab0BPFww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 00:52:52 -0500
Date: Mon, 15 Feb 2010 21:53:07 -0800 (PST)
Message-Id: <20100215.215307.118784851.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH net-next-2.6 1/2] cxgb3: FIx VLAN over Jumbo frames
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100213194429.27297.99280.stgit@speedy5.asicdesigners.com>
References: <20100213194429.27297.99280.stgit@speedy5.asicdesigners.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Sat, 13 Feb 2010 11:44:30 -0800

> From: Divy Le Ray <divy@chelsio.com>
> 
> The mac is expected to auto-inflate the Maximum Frame size for VLAN
> tagged frames. It however does not work with jumbo frames.
> Work around the bug adding 4 to the Maximum Frame for MTUs
> greater than 1536.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
