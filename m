Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147Ab0ANMtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab0ANMtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 07:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755392Ab0ANMtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 07:49:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:49620 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab0ANMtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 07:49:31 -0500
Subject: Re: [PATCH 0/6] perf: Various event scheduling improvements
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <1263087500-14215-1-git-send-regression-fweisbec@gmail.com>
References: <1263087500-14215-1-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 13:49:14 +0100
Message-ID: <1263473354.4244.316.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-10 at 02:38 +0100, Frederic Weisbecker wrote:
> Hi,
> 
> These patches bring (I hope) a bit more scalability and fairness
> to the perf events scheduling.
> 
> But this is only an introduction as there is still some work to
> do, like ensuring all pinned events have been scheduled before
> flexible ones (for now we schedule in order cpu pinned, cpu flexible,
> task pinned, task flexible), among other improvements.

Right, so 1-5 look fine (although I'd have folded 5 into 3), thanks!

