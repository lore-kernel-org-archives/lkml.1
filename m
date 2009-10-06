Return-Path: <linux-kernel-owner+w=401wt.eu-S933178AbZJFU16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933178AbZJFU16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 16:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932797AbZJFU15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 16:27:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41550 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932585AbZJFU14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 16:27:56 -0400
Date: Tue, 6 Oct 2009 16:27:13 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Breno Leitao <leitao@linux.vnet.ibm.com>
Cc: mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: improving tracepoints.txt
Message-ID: <20091006202713.GA4663@infradead.org>
References: <1254859771-8873-1-git-send-email-leitao@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254859771-8873-1-git-send-email-leitao@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 05:09:31PM -0300, Breno Leitao wrote:
> After reading the tracepoints.txt documentation, I tried to
> follow the instructions to run the sample, but just assigning
> CONFIG_SAMPLE_TRACEPOINTS=m wasn't enough to generate the tracepoints
> samples. I also need to set CONFIG_SAMPLES=y, otherwise nothing
> happens.
> 
> So, this silly patch explicit says that CONFIG_SAMPLES should be set to
> compile those files.

Actually raw tracepoints are deprecated.  Both the documentation and the
samples should be removed, with maybe a few tidbits about the consumer
side moved to the trace_event samples because they can still be used
with them.

