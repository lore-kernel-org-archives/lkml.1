Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbZJ1OW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbZJ1OW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 10:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZJ1OW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 10:22:58 -0400
Received: from mail.gmx.net ([213.165.64.20]:57944 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754050AbZJ1OW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 10:22:58 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/90fBcKA79ofqbDbmJB6r4DzJtlrIjQgiRFL1aZh
	awh/uZgxU5Pxa1
Subject: Re: hackbench regression with kernel 2.6.32-rc1
From: Mike Galbraith <efault@gmx.de>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1256722141.16282.20.camel@ymzhang>
References: <1255079943.25078.23.camel@ymzhang>
	 <1255084986.8802.46.camel@laptop>  <1255331120.3684.43.camel@ymzhang>
	 <1255357264.10420.15.camel@twins>  <1255403522.3684.57.camel@ymzhang>
	 <1255691192.7029.13.camel@marge.simson.net>
	 <1256630584.16282.13.camel@ymzhang>
	 <1256654547.17752.13.camel@marge.simson.net>
	 <1256722141.16282.20.camel@ymzhang>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Oct 2009 15:22:59 +0100
Message-Id: <1256739779.7503.59.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-28 at 17:29 +0800, Zhang, Yanmin wrote:
> 	-Mike
> I'm investigating 5% tbench regression on Nehalem machine. perf_counter shows
> select_task_rq_fair consumes about 5% cpu time with 2.6.32-rc1 while it consumes
> less than 0.5% with 2.6.31.
> 
> Patch c88d5910890 has comments to explain it, but I still can't understand why
> to add complicated balance logic when selecting task rq.
> 
> I will check which section in function ﻿select_task_rq_fair consumes so much time.

Turn off SD_WAKE_BALANCE as it was called in rc1.  See commit 182a85f.

	-Mike

