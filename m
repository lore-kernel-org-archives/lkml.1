Return-Path: <linux-kernel-owner+w=401wt.eu-S933810AbZLFOWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933810AbZLFOWc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 09:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933784AbZLFOWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 09:22:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:39263 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933637AbZLFOW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 09:22:28 -0500
Date: Sun, 6 Dec 2009 11:42:04 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: perf DEBUG=1 build fails due to perl bindings
Message-ID: <20091206134203.GA4337@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[acme@ana linux-2.6-tip]$ make DEBUG=1 -j3 -C tools/perf/ install
make: Entering directory `/home/acme/git/linux-2.6-tip/tools/perf'
    LINK perf
libperf.a(trace-event-perl.o): In function `xs_init':
/home/acme/git/linux-2.6-tip/tools/perf/util/trace-event-perl.c:43: undefined reference to `boot_Perf__Trace__Context'
/home/acme/git/linux-2.6-tip/tools/perf/util/trace-event-perl.c:45: undefined reference to `boot_DynaLoader'
collect2: ld returned 1 exit status
make: *** [perf] Error 1
make: Leaving directory `/home/acme/git/linux-2.6-tip/tools/perf'
[acme@ana linux-2.6-tip]$
