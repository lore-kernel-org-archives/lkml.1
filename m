Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYG1DLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYG1DLl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 23:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbYG1DLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 23:11:33 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:35566 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbYG1DLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 23:11:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WKgeem1TYqz82HH7yHa2bJIwou8Iy41AJzFzzrPGre6PDi2L6chBkhj9v302e8ZhuF
         PKXjWn2Xg1Y4NVNnkA2wLCMUdGo1et9fQk3q1P5WdHEe9CNdng59v0nF8le+LqzIgLZm
         3EU/Q9SOLjiubussV8PdSCw6IXR4db2VS6x3w=
Subject: Re: [PATCH] FILESYSTEMS: Make "advanced partitions" immediately
 unselectable.
From: Calvin Walton <calvin.walton@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <alpine.LFD.1.10.0807261750340.3493@localhost.localdomain>
References: <alpine.LFD.1.10.0807241135540.5289@localhost.localdomain>
	 <20080726094718.b617c1e7.randy.dunlap@oracle.com>
	 <alpine.LFD.1.10.0807261750340.3493@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 27 Jul 2008 23:11:29 -0400
Message-Id: <1217214689.22927.3.camel@zem.phub.net.cable.rogers.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-07-26 at 17:52 -0400, Robert P. J. Day wrote:
> On Sat, 26 Jul 2008, Randy Dunlap wrote:
> 
> > On Sat, 26 Jul 2008 09:20:49 -0400 (EDT) Robert P. J. Day wrote:
> >
> > >
> > > Use "menuconfig" to allow all advanced partitions to be deselectable
> > > from the top-level FS menu.
> > >
> > > Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> >
> > Hi,
> >
> > I like the idea, but it does have one problem.  Before this patch,
> > if someone disabled PARTITION_ADVANCED, the .config would still
> > contain CONFIG_MSDOS_PARTITION=y but after this change, that config
> > line is missing.  Not good.
> 
> ah, quite right.  the obvious solution is to move MSDOS_PARTITION out
> of there since it doesn't even *remotely* qualify as an "advanced"
> partition -- it's about as basic as it gets.  i'll ponder and
> resubmit.

It's not that any of the partition types in the menu are advanced - it's
that the menu lets an "advanced" user add or remove support for
partitions types that are not native to their platform. This is so
someone can, say, mount a sparc scsi disk on an x86 box.

-- 
Calvin Walton <calvin.walton@gmail.com>

