Return-Path: <linux-kernel-owner+w=401wt.eu-S1757321AbYBEIQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbYBEIQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 03:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbYBEIQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 03:16:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292AbYBEIQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 03:16:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: make traps on 'iret' be debuggable in user
	space
In-Reply-To: Roland McGrath's message of  Tuesday, 5 February 2008 00:15:06 -0800 <20080205081506.655CB2701A8@magilla.localdomain>
X-Fcc: ~/Mail/linus
References: <20080205075137.617012701A8@magilla.localdomain>
	<20080205080149.GA16929@elte.hu>
	<20080205081506.655CB2701A8@magilla.localdomain>
X-Shopping-List: (1) Trans-Atlantic migrant dirt
   (2) Ornery ax perversions
   (3) Prosperous rendezvous
Message-Id: <20080205081611.AD8E62701A8@magilla.localdomain>
Date: Tue,  5 Feb 2008 00:16:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > thanks, applied. I suppose you have a testcase for this that we could try?
> 
> This should exit 0 and show "wait status 0xb7f", and does on i386.
> On 2.6.24 it exits 1 and shows "wait status 0xb".

To clarify, build the case with -m32 but run on x86_64.


Thanks,
Roland
