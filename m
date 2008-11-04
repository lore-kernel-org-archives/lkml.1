Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbYKDBZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbYKDBZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 20:25:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbYKDBYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 20:24:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56878
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752221AbYKDBYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 20:24:55 -0500
Date: Mon, 03 Nov 2008 17:24:28 -0800 (PST)
Message-Id: <20081103.172428.154364341.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: increase receive packet quantum
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081103130303.29dd4e21@extreme>
References: <20081103130303.29dd4e21@extreme>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Mon, 3 Nov 2008 13:03:03 -0800

> This patch gets about 1.25% back on tbench regression.
> 
> My change to NAPI for multiqueue support changed the time limit on
> network receive processing.  Under sustained loads like tbench, this
> can cause the receiver to reschedule prematurely. 
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

I think I'm the guilty party that made that change to your
NAPI patches.

I'll apply this to net-next-2.6, thanks Stephen.
