Return-Path: <linux-kernel-owner+w=401wt.eu-S933832AbYEHWOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933832AbYEHWOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 18:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933572AbYEHWMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 18:12:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37503 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933420AbYEHWMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 18:12:52 -0400
Date: Thu, 8 May 2008 15:03:48 -0700
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: benh@kernel.crashing.org, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, tony@bakeyournoodle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Silence 'ignoring return value' warnings in
	drivers/video/aty/radeon_base.c
Message-ID: <20080508220348.GD7705@kroah.com>
References: <20080506143936.6357e578.akpm@linux-foundation.org> <20080506.144301.233784820.davem@davemloft.net> <1210121683.21644.194.camel@pasglop> <20080506182006.4b4a3968.akpm@linux-foundation.org> <1210134804.21644.202.camel@pasglop> <20080507102310.57b4ccfb@gondolin.boeblingen.de.ibm.com> <1210196621.1421.5.camel@pasglop> <20080508093421.31cd735b@gondolin.boeblingen.de.ibm.com> <1210232984.1421.47.camel@pasglop> <20080508103621.69bc47cf@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508103621.69bc47cf@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 10:36:21AM +0200, Cornelia Huck wrote:
> On Thu, 08 May 2008 17:49:44 +1000,
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > 
> > On Thu, 2008-05-08 at 09:34 +0200, Cornelia Huck wrote:
> > > 
> > > I was under the impression that failing the initialization was usually
> > > the right thing to do, since we end up with an un-configurable,
> > > un-usable device. But that may be coloured by my experience with s390
> > > devices, where we rely on sysfs attributes extensively. If indeed most
> > > sysfs files are non-vital, removing the __must_check and relying on a
> > > scary warning in the core may be fine. (OTOH, adding checks to the
> > > core
> > > has helped us to find some lurking bugs.)
> > 
> > The driver can still fail initialization if it wants... I'm just
> > objecting to the __must_check.
> 
> I hear you :) I found it useful, but it seems we should get rid of it
> for _create_file() now.

Why?  You point out it found some real bugs, should we just assume that
no new bugs of this same problem will happen again in the future?

thanks,

greg k-h
