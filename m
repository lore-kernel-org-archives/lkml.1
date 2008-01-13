Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbYAMSWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbYAMSWv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 13:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbYAMSWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 13:22:44 -0500
Received: from eazy.amigager.de ([213.239.192.238]:49726 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbYAMSWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 13:22:43 -0500
Date: Sun, 13 Jan 2008 19:22:40 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Could not set non-blocking flag with 2.6.24-rc5
Message-ID: <20080113182240.GA32695@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20071213201601.GA5831@dose.home.local> <20080112211015.GA4991@infradead.org> <20080113085655.GA3087@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080113085655.GA3087@dose.home.local>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2008 at 09:56:55 +0100, Tino Keitel wrote:
> On Sat, Jan 12, 2008 at 21:10:15 +0000, Christoph Hellwig wrote:
> > On Thu, Dec 13, 2007 at 09:16:01PM +0100, Tino Keitel wrote:
> > > Hi folks,
> > > 
> > > I often build Debian packages inside a chroot. Today I discovered a
> > > failure during an "aptitude update", which is a command to download new
> > > package lists for the package management. In strace, the lines around
> > > the failure look like this:
> > 
> > Are you using XFS?  This looks a lot like the bug I introduced where
> 
> Yes, I use XFS.
> 
> > i_rdev gets a wrong value assigned after mknod.   In that case please
> > try -rc7 as it has a fix for that particular problem.
> 
> OK, I'll try it.

I can not reproduce it anymore with 2.6.24-rc7.

Regards,
Tino
