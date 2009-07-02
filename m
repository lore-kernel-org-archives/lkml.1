Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbZGBInA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbZGBInA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 04:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbZGBImv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 04:42:51 -0400
Received: from mail.gmx.net ([213.165.64.20]:32798 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750849AbZGBImu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 04:42:50 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/sh8UxppLs/wWna51qMIU81sPUZcJSQjHBk8IPR8
	lmlpsqDHN4VZmH
Subject: Re: [patch 0/4] perf_counter tools: support annotation of live
 kernel modules
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1246519076.6384.22.camel@marge.simson.net>
References: <1246514639.13293.40.camel@marge.simson.net>
	 <20090702064712.GA26690@elte.hu>
	 <1246519076.6384.22.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 10:42:50 +0200
Message-Id: <1246524170.7113.20.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-02 at 09:17 +0200, Mike Galbraith wrote:

> After I resurrect (well, try) live annotation in top...

Random thought wrt live top annotation: instead of resurrecting in the
previous form, which could be a bit intrusive display space wise, what
do you think of this idea?

Provide a kbd input snapshot trigger which builds a perf record (hard?)
compatible file for the symbols being displayed.  Start a background
task to annotate the lot, stuffing annotate output into an output file.

Better ideas highly welcome.

	-Mike

