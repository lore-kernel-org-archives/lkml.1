Return-Path: <linux-kernel-owner+w=401wt.eu-S1761133AbXIZPYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761133AbXIZPYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760552AbXIZPYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:24:40 -0400
Received: from canuck.infradead.org ([209.217.80.40]:46598 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760432AbXIZPYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:24:39 -0400
Date: Wed, 26 Sep 2007 08:15:27 -0700
From: Greg KH <greg@kroah.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: subsystem_unregister() breakage in -mm
Message-ID: <20070926151527.GB10460@kroah.com>
References: <E1IaIs6-00051t-00@dorka.pomaz.szeredi.hu> <20070925225330.GA26235@kroah.com> <E1IaJQL-00053O-00@dorka.pomaz.szeredi.hu> <20070926024121.GA28124@kroah.com> <E1IaS5Z-0005LX-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IaS5Z-0005LX-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 10:17:45AM +0200, Miklos Szeredi wrote:
> > > BUG: failure at mm/slab.c:591/page_get_cache()!
> > > Kernel panic - not syncing: BUG!
> > 
> > Ok, here's a patch that fixes this for me.  It should go on top of the
> > -mm tree.  Let me know of this works or not.
> 
> Yes, it works for me too.  Thanks.

Great, thanks for testing and letting me know.  If only all bug reports
were this easy :)

thanks,

greg k-h
