Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbYE0SRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbYE0SRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 14:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757084AbYE0SRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 14:17:10 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:45118 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670AbYE0SRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 14:17:08 -0400
X-IronPort-AV: E=Sophos;i="4.27,549,1204531200"; 
   d="scan'208";a="72747844"
From: Roland Dreier <rdreier@cisco.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, linuxppc-dev@ozlabs.org,
       scottwood@freescale.com, torvalds@linux-foundation.org,
       tpiepho@freescale.com, alan@lxorguk.ukuu.org.uk,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: MMIO and gcc re-ordering issue
References: <1211852026.3286.36.camel@pasglop>
	<20080526.184047.88207142.davem@davemloft.net>
	<1211854540.3286.42.camel@pasglop>
	<20080526.192812.184590464.davem@davemloft.net>
	<20080526204233.75b71bb8@infradead.org>
	<1211872130.3286.64.camel@pasglop> <adaprr721c6.fsf@cisco.com>
	<1211906268.3435.44.camel@localhost.localdomain>
	<adad4n71wb3.fsf@cisco.com>
	<1211910825.7160.1.camel@localhost.localdomain>
	<adamymbvcxi.fsf@cisco.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 27 May 2008 11:17:04 -0700
In-Reply-To: <adamymbvcxi.fsf@cisco.com> (Roland Dreier's message of "Tue, 27
	May 2008 11:07:05 -0700")
Message-ID: <adaej7nvcgv.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 May 2008 18:17:04.0352 (UTC) FILETIME=[DD8F0600:01C8C025]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Writes are posted yes, but not reordered arbitrarily.

on standard x86 I mean here...
