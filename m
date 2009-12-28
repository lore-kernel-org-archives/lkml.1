Return-Path: <linux-kernel-owner+w=401wt.eu-S1751878AbZL1IFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbZL1IFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 03:05:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbZL1IFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 03:05:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39572 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbZL1IFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 03:05:03 -0500
Date: Mon, 28 Dec 2009 09:04:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 10/10] perf record: Introduce a symtab cache
Message-ID: <20091228080446.GA28652@elte.hu>
References: <1261957026-15580-1-git-send-email-acme@infradead.org>
 <1261957026-15580-10-git-send-email-acme@infradead.org>
 <20091227234020.GA29892@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091227234020.GA29892@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Em Sun, Dec 27, 2009 at 09:37:06PM -0200, Arnaldo Carvalho de Melo escreveu:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > 
> > Now a cache will be created in a ~/.debug debuginfo like hierarchy, so
> > that at the end of a 'perf record' session all the binaries (with
> > build-ids) involved get collected and indexed by their build-ids, so
> > that perf record can find them.
> 
> Gack, 'so that perf report' (and new tools, hopefully) can find them, of
> course :-\ If you notice this, please fix it up.

I fixed the log message - thanks Arnaldo.

	Ingo
