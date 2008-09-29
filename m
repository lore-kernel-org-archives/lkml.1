Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbYI2POS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbYI2POS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 11:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbYI2POI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 11:14:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57707 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbYI2POH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 11:14:07 -0400
Date: Mon, 29 Sep 2008 11:13:19 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Jeremy Kerr <jk@ozlabs.org>,
       linuxppc-dev@ozlabs.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sputrace : use marker_synchronize_unregister()
Message-ID: <20080929151319.GA25247@infradead.org>
References: <48E08B05.7030802@cn.fujitsu.com> <20080929082722.GB18663@elte.hu> <20080929151147.GH11245@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080929151147.GH11245@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 11:11:47AM -0400, Mathieu Desnoyers wrote:
> We need a marker_synchronize_unregister() before the end of exit() to make sure
> every probe callers have exited the non preemptible section and thus are not
> executing the probe code anymore.

Looks good.
