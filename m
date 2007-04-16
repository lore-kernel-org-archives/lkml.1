Return-Path: <linux-kernel-owner+w=401wt.eu-S1754372AbXDPDHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbXDPDHS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 23:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbXDPDHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 23:07:18 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36473 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754372AbXDPDHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 23:07:16 -0400
Date: Mon, 16 Apr 2007 13:07:05 +1000
From: David Chinner <dgc@sgi.com>
To: Rik van Riel <riel@redhat.com>
Cc: "David R. Litwin" <presently42@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
Message-ID: <20070416030705.GY32602149@melbourne.sgi.com>
References: <op.tqthonq5ftfxs2@localhost.localdomain> <4622C851.2030509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4622C851.2030509@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2007 at 08:50:25PM -0400, Rik van Riel wrote:
> David R. Litwin wrote:
> 
> >>4: ZFS has a HUGE capacity. I don't have 30 exobytes, but I might some
> >>day....
> >
> >ext4 will probably cope with that.  XFS definitely has very high
> >limits though I admit I don't know what they are.
> >
> >XFS is also a few exobytes.
> 
> The fsck for none of these filesystems will be able to deal with
> a filesystem that big.  Unless, of course, you have a few weeks
> to wait for fsck to complete.

Which is why I want to be able to partially offline a chunk of
a filesystem and repair it while the rest is still online.....

> Backup and restore are similar problems.  When part of the filesystem
> is lost, you don't want to have to wait for a full restore.
> 
> Sounds simple?  Well, the hard part is figuring out exactly which
> part of the filesystem you need to restore...
> 
> I don't see ZFS, ext4 or XFS addressing these issues.

XFS has these sorts of issues directly in our cross-hairs.

The major scaling problem XFS has right now is to do with
how long repair/backup/restore take when you have hundreds
of terabytes of storage.

> IMHO chunkfs could provide a much more promising approach.

Agreed, that's one method of compartmentalising the problem.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
