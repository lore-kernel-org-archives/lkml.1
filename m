Return-Path: <linux-kernel-owner+w=401wt.eu-S1757699AbYHUP7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699AbYHUP7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbYHUP73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:59:29 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:6746 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751355AbYHUP72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:59:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAKMtrUh5LD0w/2dsb2JhbAC2MYFm
X-IronPort-AV: E=Sophos;i="4.32,246,1217773800"; 
   d="scan'208";a="176604568"
Date: Fri, 22 Aug 2008 01:59:25 +1000
From: Dave Chinner <david@fromorbit.com>
To: Martin Knoblauch <knobi@knobisoft.de>
Cc: Szabolcs Szakacsits <szaka@ntfs-3g.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous
	snapshotting file system)
Message-ID: <20080821155925.GI5706@disturbed>
Mail-Followup-To: Martin Knoblauch <knobi@knobisoft.de>,
	Szabolcs Szakacsits <szaka@ntfs-3g.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com
References: <293210.50030.qm@web32606.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <293210.50030.qm@web32606.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 04:05:21AM -0700, Martin Knoblauch wrote:
>  just curious - which CCISS controller and and what kind of disk configuration are you using.

Smart Array 5300, using a single 36GB 10krpm U3SCSI disk.

Looks like most of the problems were caused by the firmware,
and are not driver related. An upgrade to a newer (2002!) firmware
appears to have fixed the worst of the problems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
