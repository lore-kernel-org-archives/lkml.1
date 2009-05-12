Return-Path: <linux-kernel-owner+w=401wt.eu-S1755744AbZELO20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744AbZELO20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 10:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZELO2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 10:28:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64757 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbZELO2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 10:28:16 -0400
Date: Tue, 12 May 2009 10:28:13 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/5] [GIT PULL] ring-buffer: optimize to 17% performance
 increase
In-Reply-To: <alpine.DEB.2.00.0905121022560.13234@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0905121027030.13234@gandalf.stny.rr.com>
References: <20090512040832.681953177@goodmis.org> <20090512083301.GA20435@elte.hu> <alpine.DEB.2.00.0905120923250.13234@gandalf.stny.rr.com> <alpine.DEB.2.00.0905121022560.13234@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 12 May 2009, Steven Rostedt wrote:
> 
> Here's the results:
> 
> size=n inline=n  270 
> size=n inline=y  290
> size=y inline=n  315
> size=y inline=y  372 (ouch!)
> 
> Thus it seems to keep both optimizations off is best for performance.

I did not run with ring buffer off on all tests, but the last one brought 
the overhead of the test up from 87 to 130.

-- Steve

