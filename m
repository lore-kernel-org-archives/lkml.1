Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbYKLJOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbYKLJOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 04:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbYKLJO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 04:14:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59693 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbYKLJO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 04:14:26 -0500
Date: Wed, 12 Nov 2008 04:14:16 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
       greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
Message-ID: <20081112091416.GA19721@infradead.org>
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <48F4568B.7000609@kernel.org> <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu> <491A96AE.3080600@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491A96AE.3080600@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 05:41:18PM +0900, Tejun Heo wrote:
> > emulated char devices to be char devices?  What I mean is, what would
> > happen if instead of a char device /dev/dsp would be a regular file
> > mounted on /dev/dsp (which implements all the necessary interfaces:
> > ioctls, poll, etc)?
> 
> For most it would work, I suppose, but there are all sorts of wonky
> users out in the wild (and quite a few that we don't have source access
> to) and different configurations, so I think it's better to appear as
> proper character device if it is a character device.  It will also help
> udev and other desktop thingies deal with devices implemented in userland.

Note that mounting a char device on /dev/dsp is exactly the same as
mounting a regular file on /dev/dsp - the only difference is what you
set i_mode to.

