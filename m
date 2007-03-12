Return-Path: <linux-kernel-owner+w=401wt.eu-S1752923AbXCLU4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbXCLU4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbXCLU4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:56:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48056
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752922AbXCLU4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:56:16 -0400
Date: Mon, 12 Mar 2007 13:56:13 -0700 (PDT)
Message-Id: <20070312.135613.78710501.davem@davemloft.net>
To: penberg@cs.helsinki.fi
Cc: amit2030@gmail.com, linux-kernel@vger.kernel.org, akpm@osdl.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] [REVISED] net/ipv4/multipath_wrandom.c: check
 kmalloc() return value.
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0703121411170.13933@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0703121411170.13933@sbz-30.cs.Helsinki.FI>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka J Enberg <penberg@cs.helsinki.fi>
Date: Mon, 12 Mar 2007 14:15:16 +0200 (EET)

> On 3/9/07, David Miller <davem@davemloft.net> wrote:
> > The whole cahce-multipath subsystem has to have it's guts revamped for
> > proper error handling.
> 
> (Untested patch follows.)

I'm not accepting untested patches, if people want to fix this
code it cannot be done in a shoddy manner any more, it will
need to be fixed and tested by people who really care about
this code.

We need real care for this code or I will remove it in 2.6.23
