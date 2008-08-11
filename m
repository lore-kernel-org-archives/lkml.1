Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbYHKPjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbYHKPjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbYHKPjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:39:35 -0400
Received: from mail.fieldses.org ([66.93.2.214]:45587 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbYHKPje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:39:34 -0400
Date: Mon, 11 Aug 2008 11:39:24 -0400
To: Benny Halevy <bhalevy@panasas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, neilb@suse.de, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] uninline nfsd4_op_name()
Message-ID: <20080811153923.GB32193@fieldses.org>
References: <20080808162642.GG14495@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808081120570.3462@nehalem.linux-foundation.org> <489ED1CF.8000308@panasas.com> <20080811030339.GA5621@fieldses.org> <489FFCB0.7080509@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489FFCB0.7080509@panasas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 11:47:44AM +0300, Benny Halevy wrote:
> On Aug. 11, 2008, 6:03 +0300, "J. Bruce Fields" <bfields@fieldses.org> wrote:
> > On Sun, Aug 10, 2008 at 02:32:31PM +0300, Benny Halevy wrote:
> >> Linus Torvalds wrote:
> >>> On Fri, 8 Aug 2008, Adrian Bunk wrote:
> >>>> There doesn't seem to be a compelling reason why nfsd4_op_name() is 
> >>>> marked as "inline":
> >> Agreed.
> >>
> >>> It should also return a "const char *", I think.
> >>>
> >>> Since it does.
> >> Right.
> > 
> > OK, I modified that to add "const" as Linus suggests, and applied to
> > 
> > 	git://linux-nfs.org/~bfields/linux.git for-2.6.27
> > 
> > Thanks to everyone.
> > 
> > --b.
> 
> Bruce, Linus already corrected and merged Adrian's patch in
> linux-2.6/master as commit f1c7f79b6ab4f7ada002a0fae47f462ede6b6857

Oops, I thought I'd checked for that, but somehow I overlooked that
commit.  Thanks.--b.
