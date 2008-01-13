Return-Path: <linux-kernel-owner+w=401wt.eu-S1751505AbYAMI5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbYAMI5Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 03:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbYAMI5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 03:57:16 -0500
Received: from eazy.amigager.de ([213.239.192.238]:51246 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbYAMI5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 03:57:15 -0500
Date: Sun, 13 Jan 2008 09:56:56 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Could not set non-blocking flag with 2.6.24-rc5
Message-ID: <20080113085655.GA3087@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20071213201601.GA5831@dose.home.local> <20080112211015.GA4991@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112211015.GA4991@infradead.org>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2008 at 21:10:15 +0000, Christoph Hellwig wrote:
> On Thu, Dec 13, 2007 at 09:16:01PM +0100, Tino Keitel wrote:
> > Hi folks,
> > 
> > I often build Debian packages inside a chroot. Today I discovered a
> > failure during an "aptitude update", which is a command to download new
> > package lists for the package management. In strace, the lines around
> > the failure look like this:
> 
> Are you using XFS?  This looks a lot like the bug I introduced where

Yes, I use XFS.

> i_rdev gets a wrong value assigned after mknod.   In that case please
> try -rc7 as it has a fix for that particular problem.

OK, I'll try it.

Regards,
Tino
