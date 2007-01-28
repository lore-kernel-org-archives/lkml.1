Return-Path: <linux-kernel-owner+w=401wt.eu-S1752457AbXA1RET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbXA1RET (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 12:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbXA1RET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 12:04:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38467 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbXA1RES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 12:04:18 -0500
Date: Sun, 28 Jan 2007 17:04:07 +0000
From: Christoph Hellwig <hch@infradead.org>
To: "Martin J. Bligh" <mbligh@mbligh.org>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: lockmeter
Message-ID: <20070128170407.GA1526@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"Martin J. Bligh" <mbligh@mbligh.org>, Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128144325.GB16552@infradead.org> <20070128152404.GB9196@elte.hu> <45BCD4C9.2030302@mbligh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BCD4C9.2030302@mbligh.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28, 2007 at 08:52:25AM -0800, Martin J. Bligh wrote:
> Mmm. not wholly convinced that's true. Whilst i don't have lockmeter
> stats to hand, the heavy time in __d_lookup seems to indicate we may
> still have a problem to me. I guess we could move the spinlocks out
> of line again to test this fairly easily (or get lockmeter upstream).

We definitly should get lockmeter in.  Does anyone volunteer for doing
the cleanup and merged?

