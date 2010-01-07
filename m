Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915Ab0AGTmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab0AGTmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:42:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867Ab0AGTmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:42:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296Ab0AGTmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:42:11 -0500
Date: Thu, 7 Jan 2010 11:41:31 -0800
From: Greg KH <gregkh@suse.de>
To: Thomas Voegtle <tv@lio96.de>
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, dmonakhov@openvz.org
Subject: Re: Linux 2.6.31.10
Message-ID: <20100107194131.GA22983@suse.de>
References: <20100106234533.GC1960@kroah.com>
 <alpine.LNX.2.00.1001071522480.5426@er-systems.de>
 <20100107180449.GA17495@suse.de>
 <alpine.LNX.2.00.1001072033301.26784@er-systems.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1001072033301.26784@er-systems.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 08:36:07PM +0100, Thomas Voegtle wrote:
> On Thu, 7 Jan 2010, Greg KH wrote:
> 
> > On Thu, Jan 07, 2010 at 03:27:21PM +0100, Thomas Voegtle wrote:
> >> Hi,
> >>
> >> On Wed, 6 Jan 2010, Greg KH wrote:
> >>> I'm announcing the release of the 2.6.31.10 kernel.  All users of the
> >>> 2.6.31 kernel series are very strongly encouraged to upgrade.
> >>
> >>
> >> Something broken here, during using a suse 11.2 installation with quota
> >> switched on (this is reproducible )
> >
> > Jan, this looks like something in the quota patches you sent.  Any
> > ideas?
> >
> > Thomas, is this on an ext3 or ext4 partition, or something else?
> 
> 
> The one with quota enabled was an ext3 partition, mounted on /

Thanks.

Could you run 'git bisect' between the two kernel versions to try to
track the problem down to the single patch?

thanks,

greg k-h
