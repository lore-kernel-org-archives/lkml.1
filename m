Return-Path: <linux-kernel-owner+w=401wt.eu-S1758955AbZDHIoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbZDHIoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755659AbZDHIoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:44:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59631 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398AbZDHIoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:44:11 -0400
Date: Wed, 8 Apr 2009 10:44:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: Re: [PATCH v2] tracing/filters: use ring_buffer_discard_commit()
	in filter_check_discard()
Message-ID: <20090408084405.GA12283@elte.hu>
References: <1239178554.10295.36.camel@tropicana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239178554.10295.36.camel@tropicana>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tom Zanussi <tzanussi@gmail.com> wrote:

> This patch changes filter_check_discard() to make use of the new 
> ring_buffer_discard_commit() function and modifies the current 
> users to call the old commit function in the non-discard case.  It 
> also introduces a version of filter_check_discard() that uses the 
> global trace buffer (filter_current_check_discard()) for those 
> cases.
> 
> v2 changes:
> 
> - fix compile error noticed by Ingo Molnar
> 
> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

Thanks Tom, i've applied it to tip:tracing/filters and i've started 
testing it.

	Ingo
