Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbXHUKnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbXHUKnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 06:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709AbXHUKnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 06:43:42 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:50097 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409AbXHUKnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 06:43:42 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [accounting regression since rc1]  scheduler updates
Date: Tue, 21 Aug 2007 12:43:15 +0200
User-Agent: KMail/1.9.7
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
References: <20070812163225.GA11996@elte.hu> <1187687476.7623.8.camel@localhost> <20070821093434.GB12025@elte.hu>
In-Reply-To: <20070821093434.GB12025@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708211243.15223.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 21. August 2007 schrieb Ingo Molnar:
> the 'invariant' i mentioned only covers scheduler behavior, not 
> accounting behavior. Accounting is separate in theory, but coupled in 
> practice now via sum_exec_runtime.

Forgot to answer about that: That means that the current design does not cover 
our requirement of showing process real time, even if we implement 
sched_clock? In that case I would suggest to merge my patch as a quick but 
correct solution and do it properly for 2.6.24. Of course better solutions 
are welcome :-)

Christian
