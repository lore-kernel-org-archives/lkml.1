Return-Path: <linux-kernel-owner+w=401wt.eu-S1757750AbYHNTlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750AbYHNTlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 15:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYHNTlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 15:41:25 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:52896 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753153AbYHNTlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 15:41:24 -0400
Date: Thu, 14 Aug 2008 15:41:11 -0400
From: Theodore Tso <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Paris <eparis@redhat.com>, tvrtko.ursulin@sophos.com,
       alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, malware-list-bounces@dmesg.printk.net,
       peterz@infradead.org, viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
Message-ID: <20080814194111.GH22488@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>,
	Eric Paris <eparis@redhat.com>, tvrtko.ursulin@sophos.com,
	alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
	Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
	malware-list-bounces@dmesg.printk.net, peterz@infradead.org,
	viro@ZenIV.linux.org.uk
References: <20080813192922.GI8232@mit.edu> <20080814093103.6CD102FE8B4@pmx1.sophos.com> <20080814132455.GE6469@mit.edu> <1218721713.3540.125.camel@localhost.localdomain> <20080814155028.GB8256@mit.edu> <1218734985.9375.5.camel@paris.rdu.redhat.com> <20080814191726.GG22488@mit.edu> <20080814193408.GA10236@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814193408.GA10236@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 03:34:08PM -0400, Christoph Hellwig wrote:
> 
> It's not used at all on regular files except for ext4 with a non-default,
> undocumented mount option.  XFS will grow it soon in a similar way as ext4,
> except that it will be documented or I might have even figured out by
> then how to just enabled it from nfsd.

We do need a standardized way of enabling it (since it does cost you
something in performance, so not everyone will want it on), and a
standardized way of reading i_version out to userspace.  Maybe a mount
option is the right way to do it, maybe not.

We may want to take this to the linux-fs list and try to get
agreements on these points; the main reason why it's not enabled by
default in ext4 is because the NFSv4 advanced caching code is in
common use (is it even in mainline)?

						- Ted
