Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbYLEIwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbYLEIwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbYLEIwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:52:06 -0500
Received: from viefep20-int.chello.at ([62.179.121.40]:42306 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbYLEIwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:52:05 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [patch] make wake-affine a sysctl variable
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ken Chen <kenchen@google.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <b040c32a0812050044g309eafb7h5b2eb29d9d8840c2@mail.gmail.com>
References: <b040c32a0812042337r7bf6282apd53e3412458d415b@mail.gmail.com>
	 <1228463394.18899.17.camel@twins>
	 <b040c32a0812050044g309eafb7h5b2eb29d9d8840c2@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 05 Dec 2008 09:51:57 +0100
Message-Id: <1228467117.18899.30.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-05 at 00:44 -0800, Ken Chen wrote:
> On Thu, Dec 4, 2008 at 11:49 PM, Peter Zijlstra wrote:
> > This patch looks like utter rubbish, sorry.
> 
> Yeah, I think turning off wake-affine completely is a lot cleaner and
> is a preferred solution.  I proposed sysctl variable earlier so that
> it can give people a knob to adjust and is more flexible.

Hehe, right, I guess I deserved that.

What I meant was, sysctl_sched_features is a horrid user interface. If
you want to expose it as a sysctl - which I still don't think we want -
create a new one that goes on/off, like sysctl_sched_wake_affine.

Anyway, is this thing you're seeing the same as pgbench, if not, care to
cook a benchmark? I really think the 1:N waker issue is solvable (not
saying its easy though).

