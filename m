Return-Path: <linux-kernel-owner+w=401wt.eu-S1759424AbYHUOOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424AbYHUOOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbYHUOOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:14:01 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:32624 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908AbYHUOOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:14:00 -0400
Date: Thu, 21 Aug 2008 16:11:07 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: jaredeh@gmail.com, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 02/10] AXFS: Kconfig and Makefiles
Message-ID: <20080821141107.GA20956@uranus.ravnborg.org>
References: <48AD00DF.9080207@gmail.com> <200808211324.22989.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808211324.22989.arnd@arndb.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 01:24:22PM +0200, Arnd Bergmann wrote:
> On Thursday 21 August 2008, Jared Hulbert wrote:
> > The Kconfig edits and Makefiles required for AXFS.
> > 
> > Signed-off-by: Jared Hulbert <jaredeh@gmail.com>
> 
> If you split out this patch separate from the files, please make it the
> *last* patch so that you cannot get build errors during a later git-bisect
> through the middle of your series.

And please use axfs-y := foo.o bar.o
as the old axfs-objs := foo.o bar.o ... syntax is deprecated.

[Replying to this mail as I lost the original]

Thanks,

	Sam
