Return-Path: <linux-kernel-owner+w=401wt.eu-S939553AbXHIRSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939553AbXHIRSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765745AbXHIRSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:18:15 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4085 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932460AbXHIRSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:18:14 -0400
Date: Thu, 9 Aug 2007 18:17:39 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, drfickle@us.ibm.com, mel@csn.ul.ie
Subject: Re: 2.6.23-rc2-mm1 -- spinlock bad magic
Message-ID: <20070809171739.GA7060@shadowen.org>
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org> <20070809125306.GA3091@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070809125306.GA3091@shadowen.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 01:53:06PM +0100, Andy Whitcroft wrote:
> Seeing spinlock bad magic BUG's from x86 and x86_64 test boxes,
> fsx-linux seems to be tickling it.  Adding Peter as prop_norm_single
> seems to be his:

Talking to Peter on IRC he suggested I back out the patch below and
retest on these machines:

	mm-dirty-balancing-for-tasks

One machine seems to have hung elsewhere (probabally another bug sigh),
and one has run the fsx-linux tests successfully.  So this patch does
seem suspect.  I will report back on the other tests when they complete.

-apw
