Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbYFTKUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbYFTKUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 06:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYFTKT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 06:19:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57829 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbYFTKT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 06:19:57 -0400
Date: Fri, 20 Jun 2008 12:19:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lockdep: add lock_class information to lock_chain and
	output it
Message-ID: <20080620101943.GA32500@elte.hu>
References: <1213951161.29952.5.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1213951161.29952.5.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_00,FR_ALMOST_VIAG2 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0034]
	2.0 FR_ALMOST_VIAG2        RAW: Almost looks like viagra.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Huang, Ying <ying.huang@intel.com> wrote:

> ﻿This patch is not intended to be merged. Just hope it is useful for 
> somebody want to investigate kernel locking behavior. The simple 
> scripts attached with the mail can be used to draw class chain graph 
> via graphviz.

hm, that looks pretty nice. Why not merge it? You could make it depend 
on LOCKDEP_DEBUG perhaps, if kernel size/performance is an issue.

	Ingo
