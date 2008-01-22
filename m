Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbYAVPiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbYAVPiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 10:38:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbYAVPh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 10:37:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51732 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbYAVPhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 10:37:55 -0500
Date: Tue, 22 Jan 2008 16:37:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: Rescheduling interrupts
Message-ID: <20080122153741.GA25547@elte.hu>
References: <200801220119.42312.caglar@pardus.org.tr> <20080122105741.GG21149@elte.hu> <200801221455.16814.caglar@pardus.org.tr> <20080122152333.GB19590@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122152333.GB19590@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4152]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


also, this might reduce the number of cross-CPU wakeups on near-idle 
systems:

  echo 1 > /sys/devices/system/cpu/sched_mc_power_savings

[ or if it doesnt, it should ;) ]

	Ingo
