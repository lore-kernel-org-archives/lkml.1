Return-Path: <linux-kernel-owner+w=401wt.eu-S934120AbZKXVoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934120AbZKXVoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933920AbZKXVoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:44:34 -0500
Received: from fallback.mail.elte.hu ([157.181.151.13]:45658 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933657AbZKXVod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:44:33 -0500
X-Greylist: delayed 2372 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Nov 2009 16:44:33 EST
Date: Tue, 24 Nov 2009 21:35:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] perf kmem: Add more functions and show more
 statistics
Message-ID: <20091124203559.GA450@elte.hu>
References: <4B0B6E44.6090106@cn.fujitsu.com>
 <20091124090425.GF21991@elte.hu>
 <4B0BA99D.5020602@cn.fujitsu.com>
 <20091124100724.GA5570@elte.hu>
 <4B0BBDBF.6050806@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0BBDBF.6050806@cn.fujitsu.com>
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> So I think some new updates on kernel perf_event break.

yeah, you were right. This commit in latest -tip should fix it:

 fe61267: perf_events: Fix bad software/trace event recursion counting

	Ingo
