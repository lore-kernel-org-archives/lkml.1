Return-Path: <linux-kernel-owner+w=401wt.eu-S1762819AbYARQRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762819AbYARQRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761518AbYARQRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:17:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51843 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761429AbYARQRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:17:42 -0500
Date: Fri, 18 Jan 2008 17:17:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, apw@shadowen.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Do not require CONFIG_HIGHMEM64G to set
	CONFIG_NUMA on x86
Message-ID: <20080118161719.GA5850@elte.hu>
References: <20080118153529.12646.5260.sendpatchset@skynet.skynet.ie> <20080118153549.12646.1915.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118153549.12646.1915.sendpatchset@skynet.skynet.ie>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mel@csn.ul.ie> wrote:

> There is nothing inherent in HIGHMEM64G required for CONFIG_NUMA to 
> work. It just limits potential testing coverage so remove the 
> limitation.

thanks Mel, applied. Great change - this will trigger NUMA related build 
(and boot) failures must faster in randconfig testing.

	Ingo
