Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbZLDAEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbZLDAEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 19:04:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbZLDAE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 19:04:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38367
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754524AbZLDAE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 19:04:28 -0500
Date: Thu, 03 Dec 2009 16:04:35 -0800 (PST)
Message-Id: <20091203.160435.208352757.davem@davemloft.net>
To: Tristram.Ha@Micrel.Com
Cc: ben@simtec.co.uk, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.32 1/3] net: Fix ks8851 snl NULL pointer
 dereference Oops
From: David Miller <davem@davemloft.net>
In-Reply-To: <14385191E87B904DBD836449AA30269D021A40@MORGANITE.micrel.com>
References: <14385191E87B904DBD836449AA30269D021A40@MORGANITE.micrel.com>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
Date: Thu, 3 Dec 2009 13:06:42 -0800

> From: Tristram Ha <Tristram.Ha@micrel.com>
> 
> This fixes the NULL pointer dereference Oops in the ks8851 snl network driver during transmission.  All socket buffers from the queue are processed inside the loop, but new workqueues have been scheduled to run.
> 
> Signed-off-by: Tristram Ha <Tristram.Ha@micrel.com>

Applied.
