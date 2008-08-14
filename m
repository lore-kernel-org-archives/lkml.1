Return-Path: <linux-kernel-owner+w=401wt.eu-S1760124AbYHNTej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124AbYHNTej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 15:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbYHNTeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 15:34:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33797 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbYHNTeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 15:34:31 -0400
Date: Thu, 14 Aug 2008 15:34:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Theodore Tso <tytso@mit.edu>, Eric Paris <eparis@redhat.com>,
       tvrtko.ursulin@sophos.com, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, Arjan van de Ven <arjan@infradead.org>,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, malware-list-bounces@dmesg.printk.net,
       peterz@infradead.org, viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
Message-ID: <20080814193408.GA10236@infradead.org>
References: <20080813192922.GI8232@mit.edu> <20080814093103.6CD102FE8B4@pmx1.sophos.com> <20080814132455.GE6469@mit.edu> <1218721713.3540.125.camel@localhost.localdomain> <20080814155028.GB8256@mit.edu> <1218734985.9375.5.camel@paris.rdu.redhat.com> <20080814191726.GG22488@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814191726.GG22488@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 03:17:26PM -0400, Theodore Tso wrote:
> On Thu, Aug 14, 2008 at 01:29:45PM -0400, Eric Paris wrote:
> > 
> > is i_version an on disk think?  didn't realize that and just assumed it
> > was in in core thing.  I wouldn't have an issue sending i_version to the
> > userspace scanner for them to use as they like.
> > 
> 
> It's on-disk for some filesystems, in order to support NFsv4 advanced
> caching semantics (which means i_version has to survive a reboot,
> which means it has to be on disk).  It is *not* on disk for ext3,
> although it is for ext4.

It's not used at all on regular files except for ext4 with a non-default,
undocumented mount option.  XFS will grow it soon in a similar way as ext4,
except that it will be documented or I might have even figured out by
then how to just enabled it from nfsd.
