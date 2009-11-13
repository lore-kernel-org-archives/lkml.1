Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbZKMIYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbZKMIYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 03:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbZKMIY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 03:24:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:55660 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbZKMIY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 03:24:27 -0500
Subject: Re: [PATCH][RFC] Measuring term of acquiring spinlock
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, tglx@linutronix.de,
       fweisbec@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20091113081722.GA14009@elte.hu>
References: <20091112.154353.680961628170545165.mitake@dcl.info.waseda.ac.jp>
	 <20091112073909.GB31719@elte.hu>
	 <20091113.132125.468378199533086916.mitake@dcl.info.waseda.ac.jp>
	 <20091113081722.GA14009@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Nov 2009 09:24:21 +0100
Message-ID: <1258100661.4039.1023.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-13 at 09:17 +0100, Ingo Molnar wrote:
> 
> 
> Btw., i think we should rename that tracepoint category from 'lockdep' 
> to 'lock'. It's possible to enable them without CONFIG_PROVE_LOCKING, 
> and they arent high-overhead in that case. 

They're still in 'lockdep', and it does still require enabling all of
the lock debugging code, so the overhead is far from zero.

