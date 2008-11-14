Return-Path: <linux-kernel-owner+w=401wt.eu-S1752184AbYKNINY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbYKNINY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 03:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbYKNINQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 03:13:16 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:54441 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbYKNINP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 03:13:15 -0500
X-SourceIP: 213.46.9.244
Subject: Re: 2.6.28-rc4: inconsistent lock state durin s2ram
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200811140045.48068.rjw@sisk.pl>
References: <1226616324.3343.58.camel@calx> <200811140045.48068.rjw@sisk.pl>
Content-Type: text/plain
Date: Fri, 14 Nov 2008 09:13:09 +0100
Message-Id: <1226650389.7685.6941.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-14 at 00:45 +0100, Rafael J. Wysocki wrote:
> On Thursday, 13 of November 2008, Matt Mackall wrote:
> > Just noticed this while looking to see if my iwlagn regression was still
> > around (doesn't seem to be):
> 
> Is this reproducible?

fixed in linus master by:

commit 5d5254f0d3b9bebc47d97e357374c0ad0c291a7d
Author: Gautham R Shenoy <ego@in.ibm.com>
Date:   Sat Oct 25 10:22:38 2008 +0530

    timers: handle HRTIMER_CB_IRQSAFE_UNLOCKED correctly from softirq context



