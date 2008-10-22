Return-Path: <linux-kernel-owner+w=401wt.eu-S1757611AbYJVWms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbYJVWms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYJVWmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:42:40 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:59070 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751501AbYJVWmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:42:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4DAM8S9kh5LE2tgWdsb2JhbACTYAEBFiKuDIFr
X-IronPort-AV: E=Sophos;i="4.33,467,1220193000"; 
   d="scan'208";a="216221413"
Date: Thu, 23 Oct 2008 09:42:35 +1100
From: Dave Chinner <david@fromorbit.com>
To: Linda Walsh <lkml@tlinx.org>, LKML <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com
Subject: Re: 2.6.27.[0,2] problems (v. 2.6.26.5): Samba & root-read-only
Message-ID: <20081022224235.GW18495@disturbed>
Mail-Followup-To: Linda Walsh <lkml@tlinx.org>,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
References: <48FED90F.7030809@tlinx.org> <20081022223005.GV18495@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022223005.GV18495@disturbed>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 09:30:05AM +1100, Dave Chinner wrote:
> On Wed, Oct 22, 2008 at 12:41:03AM -0700, Linda Walsh wrote:
> > I am having to stay at 2.6.26.5 for now on my main home server.
> >
> > Going to 2.6.27 (and just trying 2.6.27.2), I'm have two VERY weird (would
> > appear to be user-land probs from symptoms), problems. 
> >
> > 1) Samba -- the system is a Samba domain controller.  When I boot using
> > the 2.6.27.2 kernel (or .0 before), I can no longer mount any file systems
> > from my windows client. 
> .....
> >
> > 2) My root disk comes up READ-ONLY.  It uses XFS.  I am NOT able to remount
> > read/write (mount -o remount,rw /, fails writing to Read-only /etc/mtab,
> > mount -n -o remount,rw doesn't give an error message, but doesn't make the
> > drive R/W.  Root fs is on an adaptec FAST-SCSI (80MB/s) with an 18MB Seagate
> > (root, disk is oldest disk on the system). 
> 
> That XFS problem should be fixed in 2.6.27.3, whenever that is going
> to be released. It was sent and ACK'd by the stable team a week ago,
> but for some reason missed 2.6.27.2.

2.6.27.3 was released as I was writing this, so the fix is available
now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
