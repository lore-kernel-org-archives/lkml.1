Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbZHTWPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbZHTWPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 18:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbZHTWP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 18:15:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56877 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbZHTWP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 18:15:28 -0400
Date: Thu, 20 Aug 2009 18:15:28 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: perf: Problem compiling /tools/perf/Documentation in 2.6.31-rc6
Message-ID: <20090820221528.GS25206@bombadil.infradead.org>
References: <4A8D9D56.5080107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8D9D56.5080107@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 03:00:38PM -0400, Gregory Haskins wrote:
> Hi Ingo,
> 
> I'm seeing this in 2.6.31-rc6:
> 
> ghaskins@dev:~/sandbox/git/fabric/linux-2.6/tools/perf/Documentation> make
>     SUBDIR ../
> make[1]: `PERF-VERSION-FILE' is up to date.
>     ASCIIDOC perf-examples.html
> ERROR: perf-examples.txt: line 1: manpage document title is mandatory
> FAILED: perf-examples.txt: line 8: illegal style name: From an e-mail by
> Ingo Molnar
> make: *** [perf-examples.html] Error 1
> 
> It could very well be pilot error.  Any ideas?
> 

This was fixed in a recent commit to tip, probably upstream by now.
http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commitdiff;h=2932cffc89e9a1476b28a59896fa4f81e0d4f131

regards, Kyle
