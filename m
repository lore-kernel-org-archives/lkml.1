Return-Path: <linux-kernel-owner+w=401wt.eu-S1761339AbYD0Arn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761339AbYD0Arn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 20:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbYD0Arg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 20:47:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53330
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753975AbYD0Arf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 20:47:35 -0400
Date: Sat, 26 Apr 2008 17:47:35 -0700 (PDT)
Message-Id: <20080426.174735.117959877.davem@davemloft.net>
To: hpa@zytor.com
Cc: dean@arctic.org, ejbosman@cs.vu.nl, mtk.manpages@gmail.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@redhat.com,
       andrea@cpushare.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH 2/3] x86: Implement prctl PR_GET_TSC and PR_SET_TSC
From: David Miller <davem@davemloft.net>
In-Reply-To: <4813CABD.7040603@zytor.com>
References: <4813BED5.7070000@zytor.com>
	<alpine.DEB.1.10.0804261725480.6108@twinlark.arctic.org>
	<4813CABD.7040603@zytor.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 26 Apr 2008 17:37:17 -0700

> dean gaudet wrote:
> >>>
> >> PR_SET/PR_GET are the common prefixes, though.
> > 
> > that's not what's at issue... "PR_SET_TSC" reads "set the TSC" ... it 
> > doesn't read "set the ability to use the rdtsc instruction". 
> > PR_SET_RDTSC_ENABLE would seem to be more accurate... or even 
> > PR_SET_CR4_TSD which is what it really does :)
> > 
> 
> The whole point I'm making is that any such name would inherently read 
> x86-specific.

Agreed.
