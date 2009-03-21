Return-Path: <linux-kernel-owner+w=401wt.eu-S1757021AbZCUMIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbZCUMIj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 08:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbZCUMI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 08:08:28 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:60930 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbZCUMI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 08:08:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18884.55477.226691.317000@cargo.ozlabs.ibm.com>
Date: Sat, 21 Mar 2009 23:08:21 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perfcounters: fix type/event_id layout on big-endian
 systems
In-Reply-To: <1237631070.24626.107.camel@twins>
References: <18884.29385.854691.357234@cargo.ozlabs.ibm.com>
	<1237631070.24626.107.camel@twins>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> Hmm, does userspace know about __BIG_ENDIAN_BITFIELD too? If not, we've
> got ourselves a problem here.

Yes, it does (I did test the patch), but I think going to explicit
shifting and masking will be better.

Paul.
