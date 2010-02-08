Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab0BHN4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 08:56:24 -0500
Received: from cantor.suse.de ([195.135.220.2]:39526 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074Ab0BHN4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 08:56:22 -0500
Date: Mon, 8 Feb 2010 14:56:29 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
       Kazuo Moriwaka <moriwaka@redhat.com>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Joel Becker <joel.becker@oracle.com>, linux-ext4@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH] obsolete config in kernel source (BUFFER_DEBUG)
Message-ID: <20100208135629.GD4321@quack.suse.cz>
References: <20100205131333.GB6540@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100205131333.GB6540@faui49.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 05-02-10 14:13:33, Christoph Egger wrote:
> Hi all!
> 
> 	As part of the VAMOS[0] research project at the University of
> Erlangen we're checking referential integrity between kernel KConfig
> options and in-code Conditional blocks.
> 
> 	With some commit somewhere around 2.4.15 the last hint of
> CONFIG_BUFFER_DEBUG (apart from the 2 occurences this patch addresses)
> -- some documentation -- was removed from the kernel source. However
> this one piece of code made it till today. Time to go forward and
> remove it?
> 
> 	Please keep me informed of this patch getting confirmed /
> merged so we can keep track of it.
  Thanks, the patch looks good. I've merged it into my linux-fs tree and
will send it to Linus in the next merge window.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
