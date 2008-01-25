Return-Path: <linux-kernel-owner+w=401wt.eu-S1759491AbYAYXL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491AbYAYXL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 18:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758321AbYAYXLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 18:11:40 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:45285 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757965AbYAYXLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 18:11:38 -0500
Date: Sat, 26 Jan 2008 00:11:33 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Michael Holzheu <holzheu@de.ibm.com>,
       Volker Sameske <sameske@de.ibm.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH 085/196] kset: convert s390 ipl.c to use kset_create
Message-ID: <20080125231017.GA20351@osiris.ibm.com>
References: <20080125071127.GA4860@kroah.com> <1201246425-5058-6-git-send-email-gregkh@suse.de> <20080125122052.GA9080@osiris.ibm.com> <20080125174858.GB4242@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125174858.GB4242@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 09:48:58AM -0800, Greg KH wrote:
> On Fri, Jan 25, 2008 at 01:20:53PM +0100, Heiko Carstens wrote:
> > On Thu, Jan 24, 2008 at 11:31:54PM -0800, Greg Kroah-Hartman wrote:
> > > Dynamically create the kset instead of declaring it statically.
> > > This makes the kobject attributes now work properly that I broke in the
> > > previous patch.
> > 
> > Could you please merge this and the previous patch before it goes
> > upstream? Having an intermediate state where things are broken
> > will cause pain and additional work in case of bisecting.
> 
> It will not cause a build error (see the previous patch for details.)
> The sysfs files will not properly show the correct data, that is all.
>
> The odds that you will hit this in a 'git bisect' is VERY low, and the
> previous patch states that the files are now broken, so there should not
> be any confusion regarding any user that might run across this.

The odds are very low, as long as not more patch sets come up which
introduce intermediate broken kernels.
What exactly is the advantage of breaking the kernel with patch 1 and
then fix it again with patch 2 instead of doing the straight forward
conversions all with one patch?
