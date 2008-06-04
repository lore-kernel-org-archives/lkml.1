Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbYFDFpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbYFDFpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 01:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbYFDFpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 01:45:21 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59914 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751164AbYFDFpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 01:45:20 -0400
X-Sasl-enc: Ta3GnHOYH7pctw0nKkCbK6AG87ZJxcLD7S+ozLq3Ikdf 1212558318
Subject: Re: Linux 2.6.26-rc4
From: Ian Kent <raven@themaw.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, jmoyer@redhat.com, torvalds@linux-foundation.org,
       jesper@krogh.cc, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <E1K3ldP-0007pW-OA@pomaz-ex.szeredi.hu>
References: <20080603105258.GV28946@ZenIV.linux.org.uk>
	 <1212499623.3025.46.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org>
	 <1212509263.3025.66.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030926330.3473@woody.linux-foundation.org>
	 <1212513189.3025.101.camel@raven.themaw.net>
	 <20080603173029.GD28946@ZenIV.linux.org.uk>
	 <x49ej7ejtry.fsf@segfault.boston.devel.redhat.com>
	 <20080603191859.GG28946@ZenIV.linux.org.uk>
	 <x49abi2jnwf.fsf@segfault.boston.devel.redhat.com>
	 <20080603230026.GH28946@ZenIV.linux.org.uk>
	 <1212547323.3146.45.camel@raven.themaw.net>
	 <E1K3ldP-0007pW-OA@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 13:41:57 +0800
Message-Id: <1212558119.3146.46.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-06-04 at 07:34 +0200, Miklos Szeredi wrote:
> > Perhaps, if we didn't use /etc/mtab anywhere.
> > It would make a difference if we could "mount" /proc/mounts onto a file
> > such as /etc/mtab and everyone always did that.
> 
> That's actually remarkably close to being possible.  Loopback mounts
> have already been fixed not to rely on /etc/mtab.  The only major
> piece missing is "user" mounts, and there's already a patchset for
> that waiting for review by the VFS maintainers.  After that, it's just
> a "simple" issue of fixing up all the userspace pieces.  Could be
> finished in the next decade, possibly ;)

;)


