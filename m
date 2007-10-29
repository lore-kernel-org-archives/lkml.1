Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbXJ2BJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbXJ2BJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 21:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbXJ2BJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 21:09:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55544
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752475AbXJ2BJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 21:09:47 -0400
Date: Sun, 28 Oct 2007 18:09:49 -0700 (PDT)
Message-Id: <20071028.180949.233462591.davem@davemloft.net>
To: kyle@mcmartin.ca
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Only show RESOURCES_64BIT on relevant architectures
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071028201549.GA23138@fattire.cabal.ca>
References: <20071028201549.GA23138@fattire.cabal.ca>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@mcmartin.ca>
Date: Sun, 28 Oct 2007 16:15:49 -0400

> To quote lolcats: CONFIG_RESOURCES_64BIT DO NOT WANT!
> 
> I *think* I have the logic of this right... Anyway, I was annoyed by
> having to do the bloody ugly casts to unsigned long long in
> arch-specific code. As near as I can tell, we only want this selectable
> in the case of PAE on x86, and some random PPC and MIPS embedded boards.
> 
> For everyone else, it should be whatever the value of 64BIT is.
> 
> And I can be happy and continue using unsigned long and going about my
> merry business.
> 
> Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>

32-bit sparc has 36-bit physical addresses and thus needs
64-bit resources too
