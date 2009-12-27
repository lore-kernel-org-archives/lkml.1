Return-Path: <linux-kernel-owner+w=401wt.eu-S1751282AbZL0Xka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282AbZL0Xka (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 18:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750935AbZL0Xk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 18:40:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:56062 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbZL0Xk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 18:40:27 -0500
Date: Sun, 27 Dec 2009 21:40:20 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 10/10] perf record: Introduce a symtab cache
Message-ID: <20091227234020.GA29892@ghostprotocols.net>
References: <1261957026-15580-1-git-send-email-acme@infradead.org> <1261957026-15580-10-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261957026-15580-10-git-send-email-acme@infradead.org>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Dec 27, 2009 at 09:37:06PM -0200, Arnaldo Carvalho de Melo escreveu:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Now a cache will be created in a ~/.debug debuginfo like hierarchy, so
> that at the end of a 'perf record' session all the binaries (with
> build-ids) involved get collected and indexed by their build-ids, so
> that perf record can find them.

Gack, 'so that perf report' (and new tools, hopefully) can find them, of
course :-\ If you notice this, please fix it up.
 
- Arnaldo
