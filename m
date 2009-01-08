Return-Path: <linux-kernel-owner+w=401wt.eu-S1760067AbZAHOlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbZAHOlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 09:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZAHOlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 09:41:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56199 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbZAHOlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 09:41:01 -0500
Date: Thu, 8 Jan 2009 15:40:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Robert Richter <robert.richter@amd.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] ring_buffer: fix ring_buffer_event_length()
Message-ID: <20090108144046.GB18120@elte.hu>
References: <alpine.DEB.1.10.0901072356480.14345@gandalf.stny.rr.com> <20090108115958.GB1539@elte.hu> <alpine.DEB.1.10.0901080927340.22642@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901080927340.22642@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Thu, 8 Jan 2009, Ingo Molnar wrote:
> > 
> > That is a pretty useless duplication of the subject line, so i dropped it. 
> > When the subject line explains the practical impact already, there's no 
> > need to add the impact line.
> 
> Actually, Frederic and I had a discussion about a duplicate Impact line. 
> Perhaps someone is searching the git log on "Impact:" looking for all 
> fixes. Perhaps just a simple:
> 
> Impact: fix
> 
> would be sufficient?

hm, okay - but it should be somewhat different. The impact line should 
really be a 'description of impact/risk'. That overlaps subject lines some 
of the time - but often not. So we could do something more specific like:

  Impact: change/fix (unused) ring-buffer API to be more useful

(For future commits.)

	Ingo
