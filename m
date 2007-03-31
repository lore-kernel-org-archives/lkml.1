Return-Path: <linux-kernel-owner+w=401wt.eu-S933613AbXCaEz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933613AbXCaEz4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 00:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933541AbXCaEzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 00:55:03 -0400
Received: from [212.12.190.20] ([212.12.190.20]:32891 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933589AbXCaEyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 00:54:38 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [test] hackbench.c interactivity results: vanilla versus
Date: Sat, 31 Mar 2007 07:58:15 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703310758.15339.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> Yesterday, I piddled around with tracking interactive backlog as a way
> to detect when the load isn't really an interactive load, that's very
> simple and has potential.

You may want to consider fixing latencies per nice relative to load, as the 
biggest problem with iab are huge latency delays, which exhibit themselves 
as starvation, caused by unfair timeslice management.


Thanks!

--
Al

