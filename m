Return-Path: <linux-kernel-owner+w=401wt.eu-S1752936AbZLAGWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbZLAGWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 01:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbZLAGWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 01:22:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:43691 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbZLAGWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 01:22:31 -0500
Date: Mon, 30 Nov 2009 22:24:31 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?RnLDqWTDqXJpYw==?= Weisbecker <f.weisbecker@gmail.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] perf timechart: Remove open-coded event parsing
 code
Message-ID: <20091130222431.78a300e7@infradead.org>
In-Reply-To: <4B14B21C.2040406@cn.fujitsu.com>
References: <4B14B201.9030708@cn.fujitsu.com>
	<4B14B21C.2040406@cn.fujitsu.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Dec 2009 14:05:16 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:
> -		size = 8;
> +	if (!(sample_type & PERF_SAMPLE_RAW)) {
> +		fprintf(stderr,
> +			"No trace sample to read. Did you call perf
> record "
> +			"without -R?");
> +		return -1;
>  	}

while I like your cleanup... I am not so sure this printk makes sense
whatsoever.... the user did not use "perf record" to get here...



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
