Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbZBDJrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbZBDJrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 04:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbZBDJrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 04:47:16 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59561
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750866AbZBDJrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 04:47:15 -0500
Date: Wed, 04 Feb 2009 01:47:09 -0800 (PST)
Message-Id: <20090204.014709.208354803.davem@davemloft.net>
To: lists@nerdbynature.de
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: Kernel unaligned access at TPC
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.00.0902041001550.4084@bogon.housecafe.de>
References: <alpine.DEB.2.00.0902041001550.4084@bogon.housecafe.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Kujau <lists@nerdbynature.de>
Date: Wed, 4 Feb 2009 10:07:52 +0100 (CET)

> 
> [   94.099721] Kernel unaligned access at TPC[54c818] nsm_get_handle+0x158/0x400
> [   94.336558] Kernel unaligned access at TPC[54c81c] nsm_get_handle+0x15c/0x400
> [   94.678623] Kernel unaligned access at TPC[54c818] nsm_get_handle+0x158/0x400
> [   94.915452] Kernel unaligned access at TPC[54c81c] nsm_get_handle+0x15c/0x400
> [   95.252917] Kernel unaligned access at TPC[54c818] nsm_get_handle+0x158/0x400
> 
> Searching the net only brought up a post[0] from kernel-testers, but this 
> box here is running fine - no filesystem errors or anything. Are these 
> messages something to worry about or can they be ignored?

You can safely ignore it, but it should get fixed.
