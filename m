Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbXJHLjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbXJHLjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 07:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbXJHLjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 07:39:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56621 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbXJHLjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 07:39:13 -0400
Date: Mon, 8 Oct 2007 13:39:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/6] scheduler: Refactor common code of sleep_on /
	wait_for_completion v2
Message-ID: <20071008113906.GB22199@elte.hu>
References: <200710071059.126674000@suse.de> <20071007205955.4D60E1474B@wotan.suse.de> <p731wc65zvw.fsf_-_@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p731wc65zvw.fsf_-_@bingen.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0095]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> Andi Kleen <ak@suse.de> writes:
> 
> > These functions were largely cut'n'pasted. This moves
> 
> Here's a replacement patch fixing a minor problem:
> sleep_on_common wasn't marked __sched and ended up in the 
> wrong section; breaking the WCHAN backtracing.

thanks, applied.

	Ingo
