Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbXH0NcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbXH0NcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 09:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbXH0NcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 09:32:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55859 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbXH0NcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 09:32:08 -0400
Date: Mon, 27 Aug 2007 14:31:54 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, ananth@in.ibm.com,
       prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com,
       Jim Keniston <jkenisto@us.ibm.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][kprobes] support kretprobe-blacklist
Message-ID: <20070827133154.GA22322@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Masami Hiramatsu <mhiramat@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, ananth@in.ibm.com,
	prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com,
	Jim Keniston <jkenisto@us.ibm.com>, davem@davemloft.net,
	linux-kernel@vger.kernel.org
References: <46C5FA48.2050308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C5FA48.2050308@redhat.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2007 at 03:43:04PM -0400, Masami Hiramatsu wrote:
> This patch introduces architecture dependent kretprobe
> blacklists to prohibit users from inserting return
> probes on the function in which kprobes can be inserted
> but kretprobes can not.

I don't like this at all.  If people want to shoot themselves into
their own foot using kernel modules they have an unlimited number
of ways to do this, and even more with kprobes, so there's no point
in making it a little harder for some cases.

