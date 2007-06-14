Return-Path: <linux-kernel-owner+w=401wt.eu-S1752341AbXFNSLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbXFNSLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 14:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbXFNSKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 14:10:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55926 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbXFNSKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 14:10:42 -0400
Date: Thu, 14 Jun 2007 11:12:10 -0700
From: Greg KH <greg@kroah.com>
To: Daniel Drake <dsd@gentoo.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-stable <stable@kernel.org>,
       Dave Jones <davej@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [stable]  libata spindown patches for 2.6.21-stable
Message-ID: <20070614181210.GA11421@kroah.com>
References: <4671664A.8010404@redhat.com> <20070614173051.GA9039@kroah.com> <46717F7E.2040507@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46717F7E.2040507@gentoo.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 01:48:46PM -0400, Daniel Drake wrote:
>  Greg KH wrote:
> > I think it looks way too big.
> 
>  Agreed (otherwise I would have submitted the patches already).
> 
> > If there are smaller patches, it might be a bit more reasonable.
> 
>  It may be possible to get rid of the couple of unrelated ones (sd printing, 
>  SCSI constants). These were required for the real patches to be able to 
>  build, but it would probably be easy to modify the real patches to build 
>  against kernels without those otherwise unrelated patches.
> 
> > Are there reported bugs that this patchset fixes?
> 
>  Yes, but they are not regressions - libata has never done this right until 
>  now.
> 
>  Here are a few:
>  https://bugs.gentoo.org/show_bug.cgi?id=174373
>  http://bugzilla.kernel.org/show_bug.cgi?id=7674
>  http://bugzilla.kernel.org/show_bug.cgi?id=7838
>  https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.17/+bug/67810

Ok, if people want to post some smaller patches to the stable team,
we'll be glad to consider them.

thanks,

greg k-h
