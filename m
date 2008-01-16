Return-Path: <linux-kernel-owner+w=401wt.eu-S1752990AbYAPLHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbYAPLHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 06:07:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbYAPLG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 06:06:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58827 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbYAPLG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 06:06:58 -0500
Date: Wed, 16 Jan 2008 12:06:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andy Whitcroft <andyw@uk.ibm.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: Make checkpatch.pl's quiet option not print the summary on no
	errors
Message-ID: <20080116110646.GA18366@elte.hu>
References: <477C3252.1080001@linux.intel.com> <20080115201054.GC21511@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115201054.GC21511@shadowen.org>
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


btw, just found a checkpatch.pl buglet, it gets confused on zero-sized 
files:

 $ echo -n > /tmp/1.c
 $ scripts/checkpatch.pl --file /tmp/1.c
 ERROR: Does not appear to be a unified-diff format patch

 total: 1 errors, 0 warnings, 0 lines checked

 Your patch has style problems, please review.  If any of these errors
 are false positives report them to the maintainer, see
 CHECKPATCH in MAINTAINERS.

(this broke my code-quality scriptlet)

	Ingo
