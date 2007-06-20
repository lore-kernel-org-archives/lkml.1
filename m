Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbXFTNZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbXFTNZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 09:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbXFTNZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 09:25:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52320 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbXFTNZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 09:25:43 -0400
Date: Wed, 20 Jun 2007 14:25:42 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] Union mount documentation.
Message-ID: <20070620132542.GA6169@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jan Blunck <jblunck@suse.de>, linux-kernel@vger.kernel.org
References: <20070620055050.GB4267@in.ibm.com> <20070620055157.GC4267@in.ibm.com> <1182319191.2700.9.camel@laptopd505.fenrus.org> <f5al1i$foi$1@sea.gmane.org> <20070620123223.GB4620@infradead.org> <f5b7ec$f4g$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5b7ec$f4g$1@sea.gmane.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 12:43:56PM +0000, Jan Blunck wrote:
> On Wed, 20 Jun 2007 13:32:23 +0100, Christoph Hellwig wrote:
> 
> > On Wed, Jun 20, 2007 at 07:29:55AM +0000, Jan Blunck wrote:
> >> Mounting a file system twice is bad in the first place. This should be
> >> done by using bind mounts and bind a mounted file system into a union.
> >> After that the normal locking rules apply (and hopefully work ;).
> > 
> > From the kernel POV mounting a filesystem twice is the same as doing
> > a bind mount.
> 
> Somehow I thought about doing this:
> 
>  mount /dev/dasda1 /mnt/A
>  mount /dev/dasda1 /mnt/B
> 
> ... which doesn't result in a bind mount.

But the kernel internal effect is exactly the same.  One superblock instance,
two vfsmounts referring to it. 
