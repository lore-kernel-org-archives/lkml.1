Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbYLPG5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbYLPG5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 01:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbYLPG5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 01:57:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54845
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750875AbYLPG5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 01:57:02 -0500
Date: Mon, 15 Dec 2008 22:57:03 -0800 (PST)
Message-Id: <20081215.225703.178475399.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: rostedt@goodmis.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       paulus@samba.org, benh@kernel.crashing.org
Subject: Re: local_add_return
From: David Miller <davem@davemloft.net>
In-Reply-To: <200812161703.00697.rusty@rustcorp.com.au>
References: <alpine.DEB.1.10.0812150823370.18692@gandalf.stny.rr.com>
	<200812161703.00697.rusty@rustcorp.com.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Tue, 16 Dec 2008 17:03:00 +1030

> Now, I posted a benchmark patch before for archs to test.  I'm interested
> in Sparc64.  Does any arch win from using multiple counters?  PowerPC has
> soft interrupt disable, so that solution wins over atomic_long_t for them.

I'll get you some sparc64 numbers.
