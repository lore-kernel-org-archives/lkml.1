Return-Path: <linux-kernel-owner+w=401wt.eu-S937184AbYD1Q4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937184AbYD1Q4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965335AbYD1Q4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:56:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49909 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937021AbYD1Q4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:56:04 -0400
Date: Mon, 28 Apr 2008 18:55:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] disable softlockup detection at boottime
Message-ID: <20080428165544.GE18210@elte.hu>
References: <20080423201613.GA8546@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080423201613.GA8546@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0202]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dimitri Sivanich <sivanich@sgi.com> wrote:

> This patch allows softlockup detection to be disabled by specifying a 
> boottime parameter.

good idea - but why dont you set softlockup_thresh to 0, which is the 
"off" switch already? (and that way it can be turned back on later as 
well, by the sysadmin.)

	Ingo
