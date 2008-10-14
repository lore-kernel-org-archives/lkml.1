Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbYJNXx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbYJNXx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 19:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbYJNXxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 19:53:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40911
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751626AbYJNXxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 19:53:17 -0400
Date: Tue, 14 Oct 2008 16:52:54 -0700 (PDT)
Message-Id: <20081014.165254.228300725.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
       lrg@slimlogic.co.uk
Subject: Re: linux-next: origin tree build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0810141637210.3288@nehalem.linux-foundation.org>
References: <20081015095916.f30c0979.sfr@canb.auug.org.au>
	<alpine.LFD.2.00.0810141637210.3288@nehalem.linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Oct 2008 16:43:12 -0700 (PDT)

> The proper way to test for whether an interrupt is valid or not is to do
> 
> 	if (dev->irq) {
> 		...
> 
> and no other. There is no spoon. That NO_IRQ was insane. And architectures 
> or drivers that still think otherwise should fix themselves.

Agreed.  Someone tried to add something similar to the network
driver phylib layer, and I told them similarly.
