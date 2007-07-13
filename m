Return-Path: <linux-kernel-owner+w=401wt.eu-S936770AbXGMWl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936770AbXGMWl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 18:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758946AbXGMWlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 18:41:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42491
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758502AbXGMWlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 18:41:21 -0400
Date: Fri, 13 Jul 2007 15:41:19 -0700 (PDT)
Message-Id: <20070713.154119.15263594.davem@davemloft.net>
To: clameter@sgi.com
Cc: ak@suse.de, linux-kernel@vger.kernel.org, travis@sgi.com, jeremy@goop.org
Subject: Re: x86: Convert cpu_core_map to be a per cpu variable
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0707130933140.21777@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0707122354340.17278@schroedinger.engr.sgi.com>
	<20070713.000814.102125147.davem@davemloft.net>
	<Pine.LNX.4.64.0707130933140.21777@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Fri, 13 Jul 2007 09:34:02 -0700 (PDT)

> But the code modified here is x86_64 and i386 specific? Is there an 
> overlap?

I see, the acessor is abstracted via a function.

That seems pointless, and allows you to do things like this, improving
the implementation on one set of platforms yet leave others using
SMT/multi-core scheduling behind.

It makes a lot more sense to make the implementation consistent
and therefore the improvements are seen on every platform.
