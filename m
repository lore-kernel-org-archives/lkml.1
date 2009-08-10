Return-Path: <linux-kernel-owner+w=401wt.eu-S1753852AbZHJM7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbZHJM7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 08:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbZHJM7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 08:59:39 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:15911 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbZHJM7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:59:39 -0400
X-SourceIP: 213.93.53.227
Subject: RE: [PATCH] perf_counter: Fix a race on perf_counter_ctx
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EC1BFF464@irsmsx504.ger.corp.intel.com>
References: <928CFBE8E7CB0040959E56B4EA41A77EC1BFEEE3@irsmsx504.ger.corp.intel.com>
	 <1249633282.32113.613.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFEFEB@irsmsx504.ger.corp.intel.com>
	 <20090807103127.GA23139@elte.hu> <20090807103610.GA23728@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF02D@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF048@irsmsx504.ger.corp.intel.com>
	 <20090807112421.GB30014@elte.hu> <20090807113349.GA31673@elte.hu>
	 <1249667341.17467.5.camel@twins> <20090808120315.GA14086@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF464@irsmsx504.ger.corp.intel.com>
Content-Type: text/plain
Date: Mon, 10 Aug 2009 14:59:14 +0200
Message-Id: <1249909154.17467.128.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-10 at 13:33 +0100, Metzger, Markus T wrote:

> builtin-annotate.o: In function `print_summary':
> /home/markus/linux/git-tip/tools/perf/builtin-annotate.c:1211: undefined reference to `rb_first'
> /home/markus/linux/git-tip/tools/perf/builtin-annotate.c:1223: undefined reference to `rb_next'
> builtin-annotate.o: In function `insert_source_line':

I can't seem to reproduce this build error, I'm going to look for a
machine with suitable cpu to throw this BTS stuff at.

