Return-Path: <linux-kernel-owner+w=401wt.eu-S932555AbXGKMDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbXGKMDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759826AbXGKMCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:02:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45956 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698AbXGKMCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:02:49 -0400
Date: Wed, 11 Jul 2007 13:02:47 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@infradead.org>, Mingming Cao <cmm@us.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Subject: Re: [EXT4 set 4][PATCH 4/5] i_version:ext4 inode version update
Message-ID: <20070711120247.GA26370@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mingming Cao <cmm@us.ibm.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org
References: <1183275465.4010.130.camel@localhost.localdomain> <20070711084737.GA17675@infradead.org> <20070711115224.GT6417@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711115224.GT6417@schatzie.adilger.int>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 05:52:24AM -0600, Andreas Dilger wrote:
> On Jul 11, 2007  09:47 +0100, Christoph Hellwig wrote:
> > On Sun, Jul 01, 2007 at 03:37:45AM -0400, Mingming Cao wrote:
> > > This patch is on top of i_version_update_vfs.
> > > The i_version field of the inode is set on inode creation and incremented
> > > when the inode is being modified.
> > 
> > Which is not what i_version is supposed to do.  It'll get you tons of misses
> > for NFSv3 filehandles that rely on the generation staying the same for the
> > same file.  Please add a new field for the NFSv4 sequence counter instead
> > of making i_version unuseable.
> 
> You are confusing i_generation (the instance of this inode number) with
> i_version (whether this file has been modified)?

Yes, sorry.  Objection dropped.
