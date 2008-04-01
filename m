Return-Path: <linux-kernel-owner+w=401wt.eu-S1760300AbYDAQAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300AbYDAQAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 12:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbYDAQAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 12:00:36 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:49956 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbYDAQAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 12:00:35 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [ANNOUNCE] Btrfs v0.13
Date: Tue, 1 Apr 2008 11:58:37 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
References: <200802211609.50563.chris.mason@oracle.com> <20080331.134510.126138884.davem@davemloft.net> <20080331224344.GB2362@ldl.fc.hp.com>
In-Reply-To: <20080331224344.GB2362@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804011158.37620.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 March 2008, Alex Chiang wrote:
> * David Miller <davem@davemloft.net>:
> > From: Alex Chiang <achiang@hp.com>
> > Date: Mon, 31 Mar 2008 14:26:33 -0600
> >
> > > I've gotten as far as successfully creating a btrfs filesystem
> > > (at least that's what btrfsck tells me), but haven't been able to
> > > mount it yet, probably because of the sector size issue.
> >
> > You should be able to make a filesystem with a sector
> > size >= PAGE_SIZE and it should work just fine.  Please
> > give it a try.
>
> Hrm, I'm having issues still. First, here's a patch for
> mkfs.btrfs to allow the user to pass in a different sector size.

I did this a little differently, switching to getopt_long in mkfs.btrfs and 
using [-s | --sectorsize ] for sectorsize.  -s used to be stripesize, but 
that needs to be redone for the multi-device code anyway.

You can pull down integrated versions of your patches from:

http://www.kernel.org/hg/btrfs/kernel-unstable
http://www.kernel.org/hg/btrfs/progs-unstable

Make sure to update both, there are minor format changes hidden in the 
unstable tree since you last used it.

-chris
