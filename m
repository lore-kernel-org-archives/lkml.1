Return-Path: <linux-kernel-owner+w=401wt.eu-S1762117AbZEGCKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762117AbZEGCKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 22:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760203AbZEGCKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 22:10:10 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:59729 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbZEGCKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 22:10:09 -0400
Date: Thu, 7 May 2009 11:04:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@lst.de>, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] sh: remove stray markers
Message-ID: <20090507020436.GB7938@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@lst.de>,
	rostedt@goodmis.org, linux-kernel@vger.kernel.org,
	Fr?d?ric Weisbecker <fweisbec@gmail.com>
References: <20090506103854.GA23811@lst.de> <20090506110735.GH25203@elte.hu> <20090506111209.GA25310@lst.de> <20090506111549.GJ25203@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506111549.GJ25203@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 01:15:49PM +0200, Ingo Molnar wrote:
> 
> * Christoph Hellwig <hch@lst.de> wrote:
> 
> > On Wed, May 06, 2009 at 01:07:35PM +0200, Ingo Molnar wrote:
> > > Also, if there's some current use of these markers then it's OK 
> > > to not do this change right now but replace them with 
> > > tracepoints in the v2.6.31 merge window, after both the SH and 
> > > the tracing infrastructure changes are upstream.
> > 
> > There's not user of these. [...]
> 
> I'll defer to Paul to decide whether SH needs those markers. If he 
> added them to ease his own debugging (via whatever external 
> approach), then that's an OK goal and we can handle this all 
> politely without destroying functionality, in the next merge window.
> 
They were primarily added to aid some downstream folks that were just
adding these on their own and generally not paying attention to where the
markers were being placed on subsequent merges. I don't feel too strongly
one way or the other, but as they have proven to be useful for some
people, I would rather transition over to tracepoints during the merge
window than kill them off prematurely.
