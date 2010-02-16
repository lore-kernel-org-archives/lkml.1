Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab0BPFxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 00:53:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41348
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752483Ab0BPFw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 00:52:58 -0500
Date: Mon, 15 Feb 2010 21:53:13 -0800 (PST)
Message-Id: <20100215.215313.237151931.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH net-next-2.6 2/2] cxgb3: fix link flap
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100213194435.27297.79287.stgit@speedy5.asicdesigners.com>
References: <20100213194429.27297.99280.stgit@speedy5.asicdesigners.com>
	<20100213194435.27297.79287.stgit@speedy5.asicdesigners.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Sat, 13 Feb 2010 11:44:35 -0800

> From: Divy Le Ray <divy@chelsio.com>
> 
> The driver is expected to report that the link is up
> when the phy Rx signal is established and the mac
> has not detected a link fault.
> The code is however broken, the driver does not check the link fault
> status when the phy link status changes.
> The link fault status being checked within a short period of time,
> it leads to link up/link down events.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
