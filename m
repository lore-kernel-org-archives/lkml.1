Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbYL0UB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbYL0UB5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 15:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbYL0UBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 15:01:47 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:46934 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbYL0UBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 15:01:46 -0500
Date: Sat, 27 Dec 2008 13:01:27 -0700
From: Andreas Dilger <adilger@sun.com>
Subject: Re: jbd2 inside a device mapper module
In-reply-to: <20081225143535.GA4127@blitiri.com.ar>
To: Alberto Bertogli <albertito@blitiri.com.ar>,
       Alex Zhuravlev <Alex.Zhuravlev@sun.com>
Cc: Theodore Tso <tytso@MIT.EDU>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com
Message-id: <20081227200127.GX5000@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <20081224211038.GT4127@blitiri.com.ar>
 <20081224234915.GA23723@mit.edu> <20081225143535.GA4127@blitiri.com.ar>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 25, 2008  12:35 -0200, Alberto Bertogli wrote:
> On Wed, Dec 24, 2008 at 06:49:15PM -0500, Theodore Tso wrote:
> > I have no idea why you would need to do manual __breads().  No doubt
> > I'm missing some context here.   
> 
> I'm writing (just for fun and learning purposes) a device mapper module
> that stores checksums on writes and verifies them on reads. The
> integrity metadata (currently just the checksum) is interleaved in the
> backing device: one sector holding the integrity metadata for the
> following 64 data sectors.

Alex and I discussed implementing checksums for ext4 using an external
device like this, and he might have some more design information for
you.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

