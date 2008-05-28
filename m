Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbYE1UAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbYE1UAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 16:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYE1T74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 15:59:56 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:50825 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752683AbYE1T7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 15:59:55 -0400
Date: Wed, 28 May 2008 15:59:47 -0400
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Gene Heskett <gene.heskett@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: floppy question of the hour
Message-ID: <20080528195947.GQ16162@csclub.uwaterloo.ca>
References: <200805232114.20937.gene.heskett@gmail.com> <4837DFC6.9010202@s5r6.in-berlin.de> <200805240852.58268.gene.heskett@gmail.com> <483C81DE.8060002@cfl.rr.com> <20080528134257.GA16164@csclub.uwaterloo.ca> <483DB49D.7040706@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483DB49D.7040706@cfl.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 03:38:05PM -0400, Phillip Susi wrote:
> Lennart Sorensen wrote:
> >Just do what the Amiga did:  Read the entire track into a buffer in
> >memory, then deal with the sectors, and write the entire track back. :)
> 
> IIRC, there is no way to detect the interleave factor that the media has 
> been formatted with, unless you maybe try several and see which one 
> reads fastest.

Yeah, the Amiga trick wouldn't work.  The Amiga had no interleave.  It
didn't even have sector gaps.  Just 11 consequtive sectors worth of data
per track and one gap at the end of the track.  I really doubt any other
system could emulate that floppy access method without extra hardware.

-- 
Len Sorensen
