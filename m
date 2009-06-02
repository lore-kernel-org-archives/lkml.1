Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbZFBXim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbZFBXim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 19:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbZFBXie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 19:38:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50901 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbZFBXid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 19:38:33 -0400
Date: Wed, 3 Jun 2009 01:38:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 00/12] hw-breakpoints: new hardware breakpoints API
Message-ID: <20090602233823.GB6577@elte.hu>
References: <1243982616-18212-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243982616-18212-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0006]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


had a quick testrun with this and triggered a build failure:

kernel/trace/trace_ksym.c:226: error: ksym_tracer_mutex undeclared (first use in this function)

	Ingo
