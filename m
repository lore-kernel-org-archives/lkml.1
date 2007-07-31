Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbXGaJI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbXGaJI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 05:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbXGaJIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 05:08:17 -0400
Received: from ns1.suse.de ([195.135.220.2]:48764 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbXGaJIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 05:08:16 -0400
Date: Tue, 31 Jul 2007 11:08:15 +0200
From: Jan Blunck <jblunck@suse.de>
To: Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [RFC 12/26] ext2 white-out support
Message-ID: <20070731090815.GF5101@hasse.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de> <20070730161324.261652101@weierstrass.suse.de> <20070731034515.GD25876@thunk.org> <20070731074436.GE5101@hasse.suse.de> <20070731083223.GE5469@schatzie.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731083223.GE5469@schatzie.adilger.int>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, Andreas Dilger wrote:

> On Jul 31, 2007  09:44 +0200, Jan Blunck wrote:
> > Ok, this is pretty similar to the way I implemented this for tmpfs. The
> > problem is that the union mount code is explicitly checking if the filesystem
> > is supporting whiteout. I used to use a new filesystem flag (FS_WHITEOUT) for
> > this but thought that disk filesystem like ext2/3/4 will have problem with
> > that if you mount an old image. So I guess I still need a feature flag.
> 
> You also need whiteout support for extents.  This could be done with
> unwritten extents potentially, or as I previously proposed (RFC) in
> linux-ext4.

Maybe. But this is about something totally different: a whiteout filetype, an
existing file that when it is found make the VFS return -ENOENT.

Cheers,
Jan
