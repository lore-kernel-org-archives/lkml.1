Return-Path: <linux-kernel-owner+w=401wt.eu-S1423100AbXBHP7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423100AbXBHP7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 10:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423112AbXBHP7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 10:59:42 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34348 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423100AbXBHP7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 10:59:41 -0500
Subject: Re: [patch] export ufs_fs.h to userspace
From: Arjan van de Ven <arjan@infradead.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: dushistov@mail.ru, linux-kernel@vger.kernel.org, sparc@gentoo.org
In-Reply-To: <200702081010.51790.vapier@gentoo.org>
References: <200702080246.16996.vapier@gentoo.org>
	 <1170930819.8675.36.camel@laptopd505.fenrus.org>
	 <200702081010.51790.vapier@gentoo.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 08 Feb 2007 16:59:37 +0100
Message-Id: <1170950377.8675.60.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-08 at 10:10 -0500, Mike Frysinger wrote:
> On Thursday 08 February 2007, Arjan van de Ven wrote:
> > On Thu, 2007-02-08 at 02:46 -0500, Mike Frysinger wrote:
> > > was ufs_fs.h purposefully not exported to userspace or did it just slip
> > > through the cracks ?  assuming the latter scenario, the attached patch
> > > touches up the relationship between ufs_fs.h and its sub headers (like
> > > ufs_fs_sb.h) so that we can export it ... the silo bootloader takes
> > > advantage of this header for example
> >
> > are you sure it actually uses anything from this header, and not just
> > assumes the magic number to be there??
> > (also.. I kind of would think it reasonable for things with their own
> > UFS fs reader to have their own header)
> 
> silo utilizes the structures and the random defines so that it can query UFS 
> filesystems directly

at which point arguably it should have it's own UFS header.
It's not using the UFS header to use as *kernel* interface!!

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

