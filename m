Return-Path: <linux-kernel-owner+w=401wt.eu-S934639AbXG0BTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934639AbXG0BTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 21:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761161AbXG0BT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 21:19:28 -0400
Received: from mail.fieldses.org ([66.93.2.214]:49307 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759287AbXG0BT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 21:19:27 -0400
Date: Thu, 26 Jul 2007 21:19:22 -0400
To: Neil Brown <neilb@suse.de>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lockd and nfsd endianness annotation fixes
Message-ID: <20070727011922.GC27538@fieldses.org>
References: <E1IE6Hd-0005Dl-Hu@ZenIV.linux.org.uk> <20070726220853.GN8125@fieldses.org> <18089.14397.946323.617318@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18089.14397.946323.617318@notabene.brown>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 10:11:41AM +1000, Neil Brown wrote:
> On Thursday July 26, bfields@fieldses.org wrote:
> > On Thu, Jul 26, 2007 at 05:33:49PM +0100, Al Viro wrote:
> > > 
> > 
> > Oops, thanks; these are my fault.
> > 
> > (How are you finding these?  I was assuming sparse, but running a make
> > -C2 just now I didn't see anything that would have suggested these
> > fixes.  I'm using whatever's current in Fedora--it says 0.3-1.fc7.  Do I
> > need something more recent?)
> 
> I have a note about that somewhere.....
> 
> > From: Al Viro <viro@ftp.linux.org.uk>
> > Subject: Re: [PATCHSET] nfs endianness annotations
> > Date: Thu, 19 Oct 2006 02:26:00 +0100
> > ....
> > 
> > Folks, seriously, please run sparse after changes; it's a simple matter of
> > make C=2 CF=-D__CHECK_ENDIAN__ fs/nfs*/; nothing tricky and it saves a lot
> > of potential PITA...
> 
> And with lots of good intentions, I ran this about once, and promptly
> forgot.

Thanks, uh, I probably saw that message too.

Hm, trying it just now--it catches the svclock.c mistake, but not the
one in nfsd/nfs4xdr.c--at least not as far as I can tell.

--b.
