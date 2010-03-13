Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084Ab0CMUKY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 15:10:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55807
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757204Ab0CMUKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 15:10:23 -0500
Date: Sat, 13 Mar 2010 12:10:44 -0800 (PST)
Message-Id: <20100313.121044.180110930.davem@davemloft.net>
To: stefani@seibold.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] fix PHY polling system blocking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1268481242.4885.70.camel@wall-e>
References: <1267894258.18869.2.camel@wall-e>
	<20100312144248.ade8b700.akpm@linux-foundation.org>
	<1268481242.4885.70.camel@wall-e>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>
Date: Sat, 13 Mar 2010 12:54:02 +0100

> There is not real drawback, only the detection of a connection type
> change without unplugging the cable will not work. But this is more an
> esoteric use case.

I don't think it's so esoteric.

We should definitely notice all link state and capability changes.

If proper functionality cannot be done without an expensive operation,
it doesn't mean we take away the proper functionality.

I really don't agree with these changes, sorry.
