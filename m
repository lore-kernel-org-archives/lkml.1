Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbXITUWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbXITUWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 16:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbXITUWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 16:22:01 -0400
Received: from mail.fieldses.org ([66.93.2.214]:50474 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbXITUWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 16:22:00 -0400
Date: Thu, 20 Sep 2007 16:21:56 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>,
       Neil Brown <neilb@suse.de>, Trond Myklebust <trond@netapp.com>,
       stable@kernel.org
Subject: Re: [PATCH] rpc: fix garbage in printk in svc_tcp_accept()
Message-ID: <20070920202156.GF23287@fieldses.org>
References: <20070920195146.GC23287@fieldses.org> <alpine.LFD.0.999.0709201310230.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709201310230.16478@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 01:15:05PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 20 Sep 2007, J. Bruce Fields wrote:
> >
> > we upgraded the kernel of a nfs-server from 2.6.17.11 to 2.6.22.6. Since
> > then we get the message
> ...
> 
> Bruce - you're losing authorship information.

Whoops, yes, I usually rely on git-send-email to do that, but was
sending the patch by hand this time in a hurry, reading the commit into
my mail client, and forgot the From: line.  Thanks for catching that.

> So that "always explicitly say who the author is" is a good idea, but when 
> forwarding somebody elses patch, it's *more* than a good idea - at that 
> point it's absolutely required for proper attribution.

Yeah, I know.  Apologies.--b.
