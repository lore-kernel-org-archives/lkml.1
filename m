Return-Path: <linux-kernel-owner+w=401wt.eu-S1758355AbYILWrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355AbYILWrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 18:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757311AbYILWrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 18:47:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48116 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757270AbYILWrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 18:47:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: David Miller <davem@davemloft.net>
X-Fcc: ~/Mail/linus
Cc: rmk+lkml@arm.linux.org.uk, linux-arch@vger.kernel.org,
       utrace-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_HAVE_ARCH_TRACEHOOK and you
In-Reply-To: David Miller's message of  Friday, 12 September 2008 15:40:15 -0700 <20080912.154015.93377289.davem@davemloft.net>
References: <20080912223156.51D4815420D@magilla.localdomain>
	<20080912.153703.21849753.davem@davemloft.net>
	<20080912223926.5EF0715420D@magilla.localdomain>
	<20080912.154015.93377289.davem@davemloft.net>
X-Shopping-List: (1) Pretentious rectums
   (2) Valiant detection buttons
   (3) Concomitant accordion ignorers
   (4) Static traitorous honkers
   (5) Phosphorescent self-propelled itinerant proteins
Message-Id: <20080912224554.61CCB15420D@magilla.localdomain>
Date: Fri, 12 Sep 2008 15:45:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Didn't it also write NT_PRFPREG notes of the wrong size?
> 
> Yep, but gdb was "generous in what it received" and happily
> read the contents.

Ah.  I've always done core sanity checks with:
	1. generate core1 on old kernel
	2. generate core2 on new kernel (identical userland scenario)
	3. eu-readelf -nl core1 > a
	4. eu-readelf -nl core2 > b
	5. diff -u a b
Then you can eyeball any expected drift like SP address randomization,
and be suspicious of all other differences.  (Of course, I also test
that gdb still likes it.)


Thanks,
Roland
