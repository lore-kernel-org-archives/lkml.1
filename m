Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbZJFP1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbZJFP1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756496AbZJFP1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:27:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:42049 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbZJFP1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:27:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Kc2Fv8IL5FFVumQEm7KTqK/NeryDEVra/CdnTOQsa5aylBTkZa7rIV3Fkihb6bE7Bm
         Beb2H5YEgOSKsIm3xPOXikzF6NXwDVX8SgKzBYFJHA1QpH3bT6rIBtceaBVn5WuQIigp
         bdlGPw4cn3OSIiG68xjMs+uFORmozfAA4OWTE=
Date: Tue, 6 Oct 2009 17:25:58 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rostedt@goodmis.org, lizf@cn.fujitsu.com
Subject: Re: [PATCH 2/3] perf trace: Update eval_flag() flags array to
	match interrupt.h
Message-ID: <20091006152556.GD5152@nowhere>
References: <1254808849-7829-1-git-send-email-tzanussi@gmail.com> <1254808849-7829-3-git-send-email-tzanussi@gmail.com> <20091006132732.GA14978@infradead.org> <20091006151858.GB5152@nowhere> <20091006152106.GA6490@infradead.org> <20091006152255.GC5152@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006152255.GC5152@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 05:22:58PM +0200, Frederic Weisbecker wrote:
> On Tue, Oct 06, 2009 at 11:21:06AM -0400, Christoph Hellwig wrote:
> > On Tue, Oct 06, 2009 at 05:19:00PM +0200, Frederic Weisbecker wrote:
> > > Yeah. We may want to do that by including trace/events/irq.h
> > > and then use the show_softirq_name() macro defined there.
> > > 
> > > The rest of the header can be wrapped through no-op macros and
> > > stub includes.
> > 
> > No, not at all.  Performance tracing tools really should not be
> > dependent on the kernel source.  This kind of creep is exactly what I
> > feared from putting the perf source in the kernel tree.
> > 
> 
> I see...
> Then the only solution I can imagine is to export a debugfs file
> in the tracing directory that provides this name resolution.
> 

I mean, not something that we would check from an offline client,
but something we could include in the traces info while recording the
traces.

