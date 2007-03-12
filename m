Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbXCLThF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbXCLThF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 15:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbXCLThF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 15:37:05 -0400
Received: from amsfep16-int.chello.nl ([62.179.120.11]:37221 "EHLO
	amsfep16-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbXCLThD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 15:37:03 -0400
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703120808110.9690@woody.linux-foundation.org>
References: <200703111457.17624.kernel@kolivas.org>
	 <1173697024.8014.19.camel@Homer.simpson.net>
	 <20070312110833.GA12835@elte.hu>  <200703122223.07048.kernel@kolivas.org>
	 <1173710082.6326.49.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0703120808110.9690@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 20:36:48 +0100
Message-Id: <1173728208.5061.3.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 08:26 -0700, Linus Torvalds wrote:

> So "good fairness" really should involve some notion of "work done for 
> others". It's just not very easy to do..

A solution that is already in demand is a class based scheduler, where
the thread doing work for a client (temp.) joins the class of the
client.

The in-kernel virtualization guys also want to have this, for pretty
much the same reasons.

Peter

