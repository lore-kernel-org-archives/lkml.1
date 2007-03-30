Return-Path: <linux-kernel-owner+w=401wt.eu-S934163AbXC3Cu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934163AbXC3Cu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 22:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934166AbXC3Cu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 22:50:59 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47928 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934163AbXC3Cu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 22:50:58 -0400
Date: Thu, 29 Mar 2007 19:31:04 -0700
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: new sysfs layout and ethernet device names
Message-ID: <20070330023104.GA21771@kroah.com>
References: <20070320170102.GA16341@nostromo.devel.redhat.com> <3ae72650703220147j42db8f79s734d4755c2fa43fd@mail.gmail.com> <20070328031743.GA11819@nostromo.devel.redhat.com> <20070328041005.GA7550@kroah.com> <20070329004138.GA23562@nostromo.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070329004138.GA23562@nostromo.devel.redhat.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 08:41:38PM -0400, Bill Nottingham wrote:
> Greg KH (greg@kroah.com) said: 
> > If you follow the rules in Documentation/ABI/testing/sysfs-class your
> > program will not have any problems.
> 
> Oh, of *course*. We add interfaces and then claim years later,
> after code has been written, "Oh, you shouldn't be using that!" in
> documentation. Meanwhile, such code using the old interface will still
> a) continue to compile b) continue to run without any sort of warnings.
> 
> If interfaces have to change, so be it. But changing the rules for
> using them years after it's implemented and then claiming "you didn't
> read the instructions" is pretty lame.

That documentation has been in the kernel tree for almost a full year:
	commit c18f6365fdbaf30611a8822afcd7097865dcaa32
	Author: Greg Kroah-Hartman <gregkh@suse.de>
	Date:   Thu Apr 27 14:10:12 2006 -0700

	    [PATCH] Add kernel<->userspace ABI stability documentation

And Kay and I have been saying to not to rely on directories for over
two years now...

Anyway, yes, older code should still "just work" if you enable the
CONFIG_SYSFS_DEPRECATED config option in the kernel, that is what it is
there for.

If you have any problems with that option enabled, please let me know
and I will be glad to fix it up.

thanks,

greg k-h
