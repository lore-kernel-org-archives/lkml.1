Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbYKSKXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbYKSKXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 05:23:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbYKSKWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 05:22:52 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54963
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751939AbYKSKWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 05:22:51 -0500
Date: Wed, 19 Nov 2008 02:22:51 -0800 (PST)
Message-Id: <20081119.022251.248772210.davem@davemloft.net>
To: mingo@elte.hu
Cc: jarkao2@gmail.com, jeff@garzik.org, johannes@sipsolutions.net,
       wferi@niif.hu, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netconsole: Disable softirqs in write_msg()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081119102145.GA15741@elte.hu>
References: <20081119101441.GB6184@elte.hu>
	<20081119.021701.133290720.davem@davemloft.net>
	<20081119102145.GA15741@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 19 Nov 2008 11:21:46 +0100

> So at least there's a partial result: it appears to not be a false 
> positive warning in the generic softirq/lockdep code.

Right, it's totally legit.
