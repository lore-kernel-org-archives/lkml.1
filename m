Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbZKHQ7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbZKHQ7p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 11:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbZKHQ7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 11:59:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57456 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbZKHQ7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 11:59:44 -0500
Date: Sun, 8 Nov 2009 17:59:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Clark Williams <williams@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: perf tools: modify perf routines to use new debugfs routines
Message-ID: <20091108165941.GA5440@elte.hu>
References: <20091108090307.0fa25a18@torg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108090307.0fa25a18@torg>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


perf doesnt build with this patch applied:

perf.o: In function `get_debugfs_mntpt':
/home/mingo/tip/tools/perf/perf.c:386: undefined reference to 
`debugfs_find_mountpoint'
libperf.a(parse-events.o): In function `print_tracepoint_events':
/home/mingo/tip/tools/perf/util/parse-events.c:782: undefined reference 
to `debugfs_valid_mountpoint'
libperf.a(parse-events.o): In function `tracepoint_id_to_path':
/home/mingo/tip/tools/perf/util/parse-events.c:165: undefined reference 
to `debugfs_valid_mountpoint'
libperf.a(parse-events.o): In function `parse_tracepoint_event':
/home/mingo/tip/tools/perf/util/parse-events.c:504: undefined reference 
to `debugfs_valid_mountpoint'
collect2: ld returned 1 exit status
make: *** [perf] Error 1

	Ingo
