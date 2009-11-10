Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbZKJThq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbZKJThq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 14:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757931AbZKJThm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 14:37:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51268 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757918AbZKJThj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 14:37:39 -0500
Date: Tue, 10 Nov 2009 20:37:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
Message-ID: <20091110193705.GA9011@elte.hu>
References: <4AF90254.40909@kernel.org>
 <alpine.LFD.2.01.0911100903370.31845@localhost.localdomain>
 <4AF9B1FD.1010408@kernel.org>
 <alpine.LFD.2.01.0911101042140.31845@localhost.localdomain>
 <4AF9BE3A.40409@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF9BE3A.40409@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> In this case, as the second function needs to release to free the old 
> map, the extra unlock/lock pair is actually necessary.  Splitting into 
> two functions is fine but I think it would be better to fix it first 
> and then split them in following patches so that it can be bisected if 
> I screw up while splitting, right?

i think Linus's point was that this hack was the last straw that broke 
the camel's back, and that we are better off with a clean solution 
straight away. If you send the clean approach i can help test it on a 
good number of boxes.

	Ingo
