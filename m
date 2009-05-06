Return-Path: <linux-kernel-owner+w=401wt.eu-S1758908AbZEFLMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908AbZEFLMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 07:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759139AbZEFLMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 07:12:33 -0400
Received: from verein.lst.de ([213.95.11.210]:48856 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758994AbZEFLMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 07:12:32 -0400
Date: Wed, 6 May 2009 13:12:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@lst.de>, rostedt@goodmis.org, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org, Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] sh: remove stray markers
Message-ID: <20090506111209.GA25310@lst.de>
References: <20090506103854.GA23811@lst.de> <20090506110735.GH25203@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506110735.GH25203@elte.hu>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 01:07:35PM +0200, Ingo Molnar wrote:
> Also, if there's some current use of these markers then it's OK to 
> not do this change right now but replace them with tracepoints in 
> the v2.6.31 merge window, after both the SH and the tracing 
> infrastructure changes are upstream.

There's not user of these.  The two only uses sets of markers are
sputrace, and kvmtrace.  I've sent a patch for the first, and the
latter is work in progress.
