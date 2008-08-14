Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbYHNUVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbYHNUVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 16:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYHNUVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 16:21:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37526 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbYHNUVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 16:21:03 -0400
Date: Thu, 14 Aug 2008 16:20:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Eric Paris <eparis@redhat.com>, tvrtko.ursulin@sophos.com,
       alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, malware-list-bounces@dmesg.printk.net,
       peterz@infradead.org, viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
Message-ID: <20080814202039.GA4509@infradead.org>
References: <20080813192922.GI8232@mit.edu> <20080814093103.6CD102FE8B4@pmx1.sophos.com> <20080814132455.GE6469@mit.edu> <1218721713.3540.125.camel@localhost.localdomain> <20080814155028.GB8256@mit.edu> <1218734985.9375.5.camel@paris.rdu.redhat.com> <20080814191726.GG22488@mit.edu> <20080814193408.GA10236@infradead.org> <20080814194111.GH22488@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814194111.GH22488@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 03:41:11PM -0400, Theodore Tso wrote:
> We do need a standardized way of enabling it (since it does cost you
> something in performance, so not everyone will want it on), and a
> standardized way of reading i_version out to userspace.  Maybe a mount
> option is the right way to do it, maybe not.
> 
> We may want to take this to the linux-fs list and try to get
> agreements on these points; the main reason why it's not enabled by
> default in ext4 is because the NFSv4 advanced caching code is in
> common use (is it even in mainline)?

I have not yet seen code actually using it at all, neither in mainline
nor on one of the many nfs development lists.

