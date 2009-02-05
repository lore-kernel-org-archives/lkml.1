Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbZBES6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbZBES6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbZBES6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:58:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42391 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbZBES6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:58:36 -0500
Date: Thu, 5 Feb 2009 19:58:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mandeep Singh Baines <msb@google.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       rientjes@google.com, mbligh@google.com, thockin@google.com
Subject: Re: [PATCH 2/2 v4] softlockup: check all tasks in hung_task
Message-ID: <20090205185819.GB20470@elte.hu>
References: <20090204194339.GB22608@elte.hu> <20090205043548.GA18933@google.com> <20090205143453.GG28443@elte.hu> <20090205094834.0dd9cfaa.akpm@linux-foundation.org> <20090205180749.GE9233@elte.hu> <20090205103050.6cd6365e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205103050.6cd6365e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 5 Feb 2009 19:07:49 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > So i amended the commit in the way below - does that look good to you?
> > 
> 
> yup.

added your ack - thanks!

> > +#define HUNG_TASK_BATCHING 1024;
> 
> s/;//

fixed.

	Ingo
