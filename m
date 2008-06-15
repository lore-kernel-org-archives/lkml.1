Return-Path: <linux-kernel-owner+w=401wt.eu-S1757040AbYFOIIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040AbYFOIIQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 04:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756052AbYFOIIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 04:08:01 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:27639
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756032AbYFOIH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 04:07:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkQBAPpqVEh8qNvt/2dsb2JhbAAIrC0
X-IronPort-AV: E=Sophos;i="4.27,647,1204470000"; 
   d="scan'208";a="235134884"
Subject: Re: how to find when a symbol introduced into the kernel
From: Ben Nizette <bn@niasdigital.com>
To: Zhaohui Wang <zwange@gmu.edu>
Cc: linux-newbie@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <000b01c8ce6b$a7bfda50$f73f8ef0$@edu>
References: <000b01c8ce6b$a7bfda50$f73f8ef0$@edu>
Content-Type: text/plain
Organization: Nias Digital
Date: Sun, 15 Jun 2008 18:08:04 +1000
Message-Id: <1213517284.3596.5.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-06-14 at 18:11 -0400, Zhaohui Wang wrote:
> 
> Hi all
> 
> To write multiple kernel version compatible programs, I need to know when a specific symbol (a struct or a function)were introduced in to the kernel tree
> 
> Binary search against multiple kernel sources is a way,but is still slow.Is there any fast way to use modern git technology to make my life easier?
> 

You can see the last time a line in a file was touched with git-blame;
that might help.

	--Ben.
