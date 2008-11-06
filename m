Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356AbYKFM1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbYKFM1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 07:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbYKFM1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 07:27:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58709 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbYKFM1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 07:27:08 -0500
Date: Thu, 6 Nov 2008 07:26:50 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       T?r?k Edwin <edwintorok@gmail.com>, srostedt@redhat.com,
       a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Identify which executable object the userspace address
	belongs to. Store thread group leader id, and use it to lookup the
	address in the process's map. We could have looked up the address
	on thread's map, but the thread might not exist by the time we are
	called. The process might not exist either, but if you are reading
	trace_pipe, that is unlikely.
Message-ID: <20081106122650.GA23474@infradead.org>
References: <1225660694-19765-1-git-send-email-edwintorok@gmail.com> <1225660694-19765-2-git-send-email-edwintorok@gmail.com> <1225660694-19765-3-git-send-email-edwintorok@gmail.com> <20081102212512.GF28946@ZenIV.linux.org.uk> <490E1B74.6010904@gmail.com> <20081102214042.GG28946@ZenIV.linux.org.uk> <20081103073257.GA13727@elte.hu> <20081104182628.GA6666@infradead.org> <20081106095547.GK4890@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106095547.GK4890@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 10:55:47AM +0100, Ingo Molnar wrote:
> > On Mon, Nov 03, 2008 at 08:32:57AM +0100, Ingo Molnar wrote:
> > > could you please help out with such a helper? This is really about 
> > > visualization, not to rely on it.
> > 
> > Is this kindergarten? [...]
> 
> No, this is lkml where, if you decide to stand in the way of a patch, 
> you are supposed to back up your NAK's with a path out of that NAK. 
> Instead of forcing people into multiple email ping-pongs trying to 
> figure out what exactly the objections mean.

Even if that was true, which would be avery sad world I should be
easy enough for you or anyone to look at what seq_path does and how
to have a version that doesn't use the seq_file insterface.  Takes
about two minutes with most of the time spent on finding where seq_file
is implemented.

