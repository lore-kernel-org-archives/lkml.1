Return-Path: <linux-kernel-owner+w=401wt.eu-S1759376AbZHRQos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbZHRQos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759342AbZHRQor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:44:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36510 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759020AbZHRQoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:44:46 -0400
Date: Tue, 18 Aug 2009 18:44:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH perf] make 'make html' work
Message-ID: <20090818164430.GA9623@elte.hu>
References: <20090818164125.GM25206@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090818164125.GM25206@bombadil.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Kyle McMartin <kyle@mcmartin.ca> wrote:

> From: Kyle McMartin <kyle@redhat.com>
> 
> pushd tools/perf/Documentation
> make html
> popd
> 
> is failing for me... 
> 
>     ASCIIDOC perf-annotate.html                                                 
> ERROR: unsafe: include file: /etc/asciidoc/./stylesheets/xhtml11.css
> ERROR: unsafe: include file:
> /etc/asciidoc/./stylesheets/xhtml11-manpage.css
> ERROR: unsafe: include file:
> /etc/asciidoc/./stylesheets/xhtml11-quirks.css
> make: *** [perf-annotate.html] Error 1
> 
> Apparently asciidoc "unsafe" is the default mode of operation
> in practice.
>
> https://bugzilla.redhat.com/show_bug.cgi?id=506953
> 
> Works tidily now.

Applied to tip:perfcounters/urgent, thanks a lot Kyle!

	Ingo
