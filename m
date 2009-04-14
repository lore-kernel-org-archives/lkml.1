Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbZDNWcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbZDNWcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 18:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbZDNWbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 18:31:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35584 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbZDNWbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 18:31:50 -0400
Subject: Re: TRACE_BRANCH_PROFILING breaks gcc warnings
From: Steven Rostedt <srostedt@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1239748090.4205.26.camel@johannes.local>
References: <1239748090.4205.26.camel@johannes.local>
Content-Type: text/plain
Organization: Red Hat
Date: Tue, 14 Apr 2009 18:31:33 -0400
Message-Id: <1239748293.21121.60.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2009-04-15 at 00:28 +0200, Johannes Berg wrote:
> With TRACE_BRANCH_PROFILING enabled you get "dummy may be used
> uninitialised" with code like the following (and gcc 4.3.3):
> 
> void *dummy, *c;
> 
> if (a && (dummy = b()))
> 	c = dummy;
> 
> Therefore, allyesconfig has become useless for looking at warnings.
> 
> :(


This has been mentioned before, and I've asked about sending a patch
that would prevent TRACE_BRANCH_PROFILING from being selected with an
allyesconfig.

It is easy to do. I could make it a selection and not a boolean and it
will not select it as default, even for allyes/modconfig

Thoughts?

-- Steve


