Return-Path: <linux-kernel-owner+w=401wt.eu-S1751147AbYE1NnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751147AbYE1NnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 09:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbYE1Nm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 09:42:59 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:33128 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751035AbYE1Nm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 09:42:58 -0400
Date: Wed, 28 May 2008 09:42:57 -0400
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Gene Heskett <gene.heskett@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: floppy question of the hour
Message-ID: <20080528134257.GA16164@csclub.uwaterloo.ca>
References: <200805232114.20937.gene.heskett@gmail.com> <4837DFC6.9010202@s5r6.in-berlin.de> <200805240852.58268.gene.heskett@gmail.com> <483C81DE.8060002@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483C81DE.8060002@cfl.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 05:49:18PM -0400, Phillip Susi wrote:
> Yes, the interleave slows you down, since after accessing sector 1, the 
> head must wait to pass over 3 other sectors before finally reaching 
> sector 2, therefore, you can only read 1/4 of the sectors on the track 
> each revolution of the disk.  That leaves 4 revolutions at 300 rpm 
> giving 0.8s to read a track, or 64 seconds to read all 80 tracks, plus 
> seek time.  That still does not explain 3 minutes though... not sure 
> what else could be slowing you down.

Just do what the Amiga did:  Read the entire track into a buffer in
memory, then deal with the sectors, and write the entire track back. :)

-- 
Len Sorensen
