Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbXGaIcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbXGaIcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 04:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbXGaIc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 04:32:28 -0400
Received: from mail.clusterfs.com ([74.0.229.162]:37849 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbXGaIcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 04:32:25 -0400
Date: Tue, 31 Jul 2007 03:32:23 -0500
From: Andreas Dilger <adilger@clusterfs.com>
To: Jan Blunck <jblunck@suse.de>
Cc: Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [RFC 12/26] ext2 white-out support
Message-ID: <20070731083223.GE5469@schatzie.adilger.int>
Mail-Followup-To: Jan Blunck <jblunck@suse.de>,
	Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bharata B Rao <bharata@linux.vnet.ibm.com>
References: <20070730161323.100048969@weierstrass.suse.de> <20070730161324.261652101@weierstrass.suse.de> <20070731034515.GD25876@thunk.org> <20070731074436.GE5101@hasse.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731074436.GE5101@hasse.suse.de>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 31, 2007  09:44 +0200, Jan Blunck wrote:
> Ok, this is pretty similar to the way I implemented this for tmpfs. The
> problem is that the union mount code is explicitly checking if the filesystem
> is supporting whiteout. I used to use a new filesystem flag (FS_WHITEOUT) for
> this but thought that disk filesystem like ext2/3/4 will have problem with
> that if you mount an old image. So I guess I still need a feature flag.

You also need whiteout support for extents.  This could be done with
unwritten extents potentially, or as I previously proposed (RFC) in
linux-ext4.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

