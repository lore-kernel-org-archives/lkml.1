Return-Path: <linux-kernel-owner+w=401wt.eu-S1756623AbZISJDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbZISJDh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 05:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbZISJDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 05:03:36 -0400
Received: from mail.gmx.net ([213.165.64.20]:47252 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752805AbZISJDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 05:03:35 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Suh5WHERS9iGgwsrT9nvLTY6gURhMnT50FJO6GB
	3KAyM5vMgJFPHO
Subject: Re: [PATCH] Prevent immediate process rescheduling
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Mark Langsdorf <mark.langsdorf@amd.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1253326605.7133.55.camel@marge.simson.net>
References: <200909181449.12311.mark.langsdorf@amd.com>
	 <20090918195455.GC11726@elte.hu>  <1253304203.10538.64.camel@laptop>
	 <1253326605.7133.55.camel@marge.simson.net>
Content-Type: text/plain
Date: Sat, 19 Sep 2009 11:03:36 +0200
Message-Id: <1253351016.7282.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.73
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-19 at 04:16 +0200, Mike Galbraith wrote:

> Sounds like Mark's case really needs a gentle_yield() that moves the
> task behind next, and slightly beyond if they are too close, but which
> also ignores the request entirely if the gap is too large.

Did that, it sucks. (not surprising really, yield _always_ sucked;)

	-Mike

