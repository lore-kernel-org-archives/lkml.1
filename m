Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbZDHHOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbZDHHOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbZDHHOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:14:11 -0400
Received: from smtp-out-43.synserver.de ([217.119.50.43]:1124 "HELO
	smtp-out-43.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750999AbZDHHOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:14:09 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 27059
Date: Wed, 8 Apr 2009 09:14:04 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Mark Lord <liml@rtr.ca>
Cc: Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <willy@linux.intel.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [PATCH 4/5] ide: Add support for TRIM
Message-ID: <20090408071404.GA2656@gentoox2.trippelsdorf.de>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <1238683047-13588-2-git-send-email-willy@linux.intel.com> <1238683047-13588-3-git-send-email-willy@linux.intel.com> <1238683047-13588-4-git-send-email-willy@linux.intel.com> <49DB8B54.7050402@garzik.org> <49DB9422.5040702@rtr.ca> <20090407181033.GA2673@gentoox2.trippelsdorf.de> <49DBB071.6000105@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DBB071.6000105@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 03:58:41PM -0400, Mark Lord wrote:
> Markus Trippelsdorf wrote:
> > On Tue, Apr 07, 2009 at 01:57:54PM -0400, Mark Lord wrote:
> >> Are there any commercially available SSDs that have this feature yet?
> >> Anyone know which ones?
> > 
> > OCZ will release a new firmware for their Vertex line in the coming
> > days, which will feature ATA TRIM support.
> > And since they get their firmware directly from Indilinx, all SSDs
> > with this controller will be TRIM ready in the future.
> > 
> > http://www.ocztechnologyforum.com/forum/showthread.php?t=54373
> ..
> 
> Mmm.. sounds like they really don't understand "standards" there.
> All of that nonsense about waiting until their proprietary "trim utility"
> is working on Windows-7 before looking at a Linux implementation.
> 
> WTF?  So long as they implement the required ATA opcode (correctly),
> then it should "just work" fine on Linux.  But that Windows-centred
> discussion there really doesn't sound encouraging.
> 
> But hey, if they do get their act together, then the Vertex series
> are supposedly the second-best consumer SSDs available these days,
> after the highly touted/priced Intel ones.  :)

The new firmware is out and looks promising:

########## Begin SSD TRIM output ##########
word21 bit10 = 1: support for the DATA SET MANAGEMENT is changeable.
word169 bit0 = 1: device supports the Trim bit of DATA SET MANAGEMENT command.
  word69 bit14 = 1: Trim function of the DATA SET MANAGEMENT command supports determinate behavior.
########## End SSD TRIM output ##########

This is the output from a modified hdparm, that checks the relevant
bits. 

(I didn't run hdparm on my machine, because I'm waiting for a flasher that
doesn't require XP. I just copied the output from:
http://www.ocztechnologyforum.com/forum/showpost.php?p=371277&postcount=28 )

-- 
Markus
