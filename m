Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559AbYJVFPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbYJVFPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 01:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbYJVFPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 01:15:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56124
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbYJVFPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 01:15:25 -0400
Date: Tue, 21 Oct 2008 22:15:02 -0700 (PDT)
Message-Id: <20081021.221502.237688944.davem@davemloft.net>
To: galak@kernel.crashing.org
Cc: joseph@codesourcery.com, linux-kernel@vger.kernel.org,
       libc-alpha@sourceware.org
Subject: Re: math-emu issue with fp divide
From: David Miller <davem@davemloft.net>
In-Reply-To: <F02EB8BE-6780-4C75-ABB9-7F2397457374@kernel.crashing.org>
References: <Pine.LNX.4.64.0806050837230.24924@blarg.am.freescale.net>
	<20080612.212457.01943346.davem@davemloft.net>
	<F02EB8BE-6780-4C75-ABB9-7F2397457374@kernel.crashing.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Gala <galak@kernel.crashing.org>
Date: Fri, 27 Jun 2008 09:15:40 -0500

> I tested this on PPC HW fp and kern emu w/my patch and get the same results:
> 
> 0
> 0
> 8000000
> 
> (8000000 is underflow in the PPC FP status register)

I did verifications of this on sparc64 as well with similar correct
results.

I'll merge your fix on the kernel side via the sparc tree, as I've
wasted enough of your time as it is :-)

Sorry for taking so long to get to this.
