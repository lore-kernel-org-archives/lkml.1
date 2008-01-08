Return-Path: <linux-kernel-owner+w=401wt.eu-S1761284AbYAHQXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761284AbYAHQXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbYAHQXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:23:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49597 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013AbYAHQXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:23:08 -0500
Date: Tue, 8 Jan 2008 17:22:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jon Masters <jcm@redhat.com>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: Re: [PATCH] kthread: always create the kernel threads with normal
	priority
Message-ID: <20080108162253.GE32273@elte.hu>
References: <20071217234314.540b59bd@hammerfall> <20071222013021.db2528cb.akpm@linux-foundation.org> <20080107110603.09b72450@brian.englab.brq.redhat.com> <20080107022513.3ac05734.akpm@linux-foundation.org> <20080107141835.44bdc7c6@brian.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080107141835.44bdc7c6@brian.englab.brq.redhat.com>
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


* Michal Schmidt <mschmidt@redhat.com> wrote:

> Allow the administrator to change kthreadd's priority and affinity. 
> Ensure that the kernel threads are created with the usual nice level 
> and affinity even if kthreadd's properties were changed from the 
> default.
> 
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

thanks Michal, applied your patch to sched-devel.git.

	Ingo
