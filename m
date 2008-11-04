Return-Path: <linux-kernel-owner+w=401wt.eu-S1756815AbYKDWsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbYKDWsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbYKDWs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:48:26 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50141
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754731AbYKDWsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:48:25 -0500
Date: Tue, 04 Nov 2008 14:48:00 -0800 (PST)
Message-Id: <20081104.144800.158229098.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: increase receive packet quantum
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081103212521.15e12168@extreme>
References: <20081103130303.29dd4e21@extreme>
	<20081103.172428.154364341.davem@davemloft.net>
	<20081103212521.15e12168@extreme>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Mon, 3 Nov 2008 21:25:21 -0800

> On Mon, 03 Nov 2008 17:24:28 -0800 (PST)
> David Miller <davem@davemloft.net> wrote:
> 
> > I'll apply this to net-next-2.6, thanks Stephen.
> 
> Maybe you want it as part of the tbench regression recovery in 2.6.28?
> it seems mostly harmless.

Maybe...

I'd rather have it cook in net-next-2.6 for a while.

Taking up more than a jiffie in softirq context is
bordering on anti-social and could cause problems
especially for RT'ish stuff.

And I'm pretty sure that's why I made the change.
