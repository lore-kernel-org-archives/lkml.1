Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbYHAHay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbYHAHay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 03:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758529AbYHAHak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 03:30:40 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:62612 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753467AbYHAHaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 03:30:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEALlWkkh5LDlw/2dsb2JhbACLIKVP
X-IronPort-AV: E=Sophos;i="4.31,291,1215354600"; 
   d="scan'208";a="162074320"
Date: Fri, 1 Aug 2008 17:30:33 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jasper Bryant-Greene <jasper@amiton.co.nz>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@lst.de
Subject: Re: XFS noikeep remount in 2.6.27-rc1-next-20080730
Message-ID: <20080801073033.GF6201@disturbed>
Mail-Followup-To: Jasper Bryant-Greene <jasper@amiton.co.nz>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@lst.de
References: <1217553598.3860.16.camel@luna.unix.geek.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217553598.3860.16.camel@luna.unix.geek.nz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'd xfs@oss.sgi.com]

On Fri, Aug 01, 2008 at 01:19:58PM +1200, Jasper Bryant-Greene wrote:
> I mount a bunch of XFS filesystems with "noikeep,attr2,noatime", and a
> couple also with "ro".
> 
> Sometimes I want to remount one of the "ro" ones "rw", to make changes.
> This doesn't work anymore in 2.6.27-rc1-next-20080730. The last kernel I
> tried which it worked in was 2.6.26 release.
> 
> luna ~ # mount -o remount,rw /usr
> mount: /usr not mounted already, or bad option
> 
> luna ~ # dmesg | tail -n 1
> [18702.291344] XFS: mount option "noikeep" not supported for remount
> 
> Is this intended behaviour?

Side effect of this commit:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-2.6.git;a=commit;h=0327f9d799ebb96f67c80dd732b1fdb09527365e

Christoph?

FWIW, noikeep is the default, so you don't need to specify it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
