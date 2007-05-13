Return-Path: <linux-kernel-owner+w=401wt.eu-S1760754AbXEMVCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760754AbXEMVCk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 17:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbXEMVCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 17:02:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49116 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbXEMVCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 17:02:32 -0400
Date: Sun, 13 May 2007 22:02:26 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Neil Brown <neilb@suse.de>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utimensat implementation
Message-ID: <20070513210226.GC14030@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Ulrich Drepper <drepper@redhat.com>, Neil Brown <neilb@suse.de>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <200704262249.l3QMn5C2021588@devserv.devel.redhat.com> <17969.22692.855242.359680@notabene.brown> <46315C61.30001@redhat.com> <464363DC.7060607@redhat.com> <20070510185226.GA1458@infradead.org> <46437613.4060407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46437613.4060407@redhat.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 12:44:19PM -0700, Ulrich Drepper wrote:
> Christoph Hellwig wrote:
> >E.g.
> >
> >long foofs_pathconf {
> >	[_PC_LINK_MAX]		= 16384,
> >	[_PC_2_SYMLINKS]	= 1,
> 
> In general I agree.  But what do you do for network filesystems?  Maybe 
> we'll have a network filesystem protocol which allows to query the 
> remote server about the underlying filesystem.  Then the return value is 
> dynamic and it's the maximum (coarsest granularity) of the network 
> filesystem itself and the underlying filesystem.

You're right, we'll probably want a method call for it.  The table
approach might still be a nice helper for the normal case.
