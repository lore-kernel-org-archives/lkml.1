Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbYE0EIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbYE0EIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 00:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbYE0EIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 00:08:13 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:61694 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbYE0EIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 00:08:12 -0400
X-IronPort-AV: E=Sophos;i="4.27,546,1204531200"; 
   d="scan'208";a="104268785"
From: Roland Dreier <rdreier@cisco.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: David Miller <davem@davemloft.net>, benh@kernel.crashing.org,
       linux-arch@vger.kernel.org, scottwood@freescale.com,
       linuxppc-dev@ozlabs.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       tpiepho@freescale.com
Subject: Re: MMIO and gcc re-ordering issue
References: <1211852026.3286.36.camel@pasglop>
	<20080526.184047.88207142.davem@davemloft.net>
	<1211854540.3286.42.camel@pasglop>
	<20080526.192812.184590464.davem@davemloft.net>
	<20080526204233.75b71bb8@infradead.org>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 26 May 2008 21:08:10 -0700
In-Reply-To: <20080526204233.75b71bb8@infradead.org> (Arjan van de Ven's
	message of "Mon, 26 May 2008 20:42:33 -0700")
Message-ID: <adad4n82xud.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 May 2008 04:08:11.0043 (UTC) FILETIME=[46F0D730:01C8BFAF]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > either via sparse or some fancy lockdep like "device store" thing?
 > If we can't test for it and it doesn't show up on x86 ... it'll just be
 > an eterrnal chase.

Ben's point is that it will start showing up on x86 because newer
compilers are reordering things...

 - R.
