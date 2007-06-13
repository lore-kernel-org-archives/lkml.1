Return-Path: <linux-kernel-owner+w=401wt.eu-S1759418AbXFMQi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759418AbXFMQi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 12:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758479AbXFMQiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 12:38:20 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:20405 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758405AbXFMQiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 12:38:19 -0400
Date: Wed, 13 Jun 2007 12:34:05 -0400
From: Chris Mason <chris.mason@oracle.com>
To: John Stoffel <john@stoffel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
Message-ID: <20070613163405.GE28279@think.oraclecorp.com>
References: <20070612161029.GB28279@think.oraclecorp.com> <18031.26764.586958.632146@stoffel.org> <20070613103522.GW28279@think.oraclecorp.com> <18031.63640.103936.137412@stoffel.org> <20070613145442.GC28279@think.oraclecorp.com> <18032.5991.475110.794691@stoffel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18032.5991.475110.794691@stoffel.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 12:12:23PM -0400, John Stoffel wrote:
> >>>>> "Chris" == Chris Mason <chris.mason@oracle.com> writes:

[ nod ]

> Also, I think you're wrong here when you state that making a snapshot
> (sub-volume?) RO just requires you to set the quota to 1 block.  What
> is to stop me from writing 1 block to a random file that already
> exists?  

It's copy on write, so changing one block means allocating a new one and
putting the new contents there.  The old blocks don't become available
for reuse until the transaction commits.

-chris

