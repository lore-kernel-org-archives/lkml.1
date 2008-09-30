Return-Path: <linux-kernel-owner+w=401wt.eu-S1753657AbYI3A2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbYI3A2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 20:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYI3A2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 20:28:34 -0400
Received: from ozlabs.org ([203.10.76.45]:38259 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbYI3A2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 20:28:33 -0400
From: Jeremy Kerr <jk@ozlabs.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] sputrace : use marker_synchronize_unregister()
Date: Tue, 30 Sep 2008 10:28:19 +1000
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linuxppc-dev@ozlabs.org,
       Christoph Hellwig <hch@infradead.org>, cbe-oss-dev@ozlabs.org
References: <48E08B05.7030802@cn.fujitsu.com> <20080929082722.GB18663@elte.hu> <20080929151147.GH11245@Krystal>
In-Reply-To: <20080929151147.GH11245@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809301028.21485.jk@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu,

> We need a marker_synchronize_unregister() before the end of exit() to
> make sure every probe callers have exited the non preemptible section
> and thus are not executing the probe code anymore.

Looks good - added to spufs.git.

Cheers,


Jeremy
