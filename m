Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbZDFOG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbZDFOG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 10:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbZDFOGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 10:06:46 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:48413 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755329AbZDFOGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 10:06:46 -0400
Date: Mon, 6 Apr 2009 10:06:44 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: Janne Grunau <j@jannau.net>, David Rees <drees76@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       tytso@mit.edu, jesper@krogh.cc,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090406140643.GL3795@csclub.uwaterloo.ca>
References: <20090403072507.GO5178@kernel.dk> <20090403142129.GH3795@csclub.uwaterloo.ca> <49D625A0.1030202@rtr.ca> <49D66A40.5020503@garzik.org> <20090403212847.GC25887@aniel> <49D68631.4030706@garzik.org> <72dbd3150904031553r3c60a3a5k45f16e0e7513d488@mail.gmail.com> <49D69C1D.50209@garzik.org> <20090404162954.GA5170@aniel> <49D7E71B.2080301@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D7E71B.2080301@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 04, 2009 at 07:02:51PM -0400, Jeff Garzik wrote:
> Is dd + sync_file_range really a realistic comparison?  dd is streaming  
> as fast as the disk can output data, whereas MythTV is streaming as fast  
> as video is being recorded.  If you are maxing out your disk throughput,  
> there will be obvious impact no matter what.
>
> I would think a more accurate comparison would be recording multiple  
> video streams in parallel, comparing fsync/fdatasync/sync_file_range?
>
> IOW, what is an average MythTV setup -- what processes are actively  
> reading/writing storage?  Where are you noticing latencies, and does  
> sync_file_range decrease those areas of high latency?

I am going to give the patch a shot.  I run dual tuners after all, so
I do get multiple streams recording while doing playback at the same time.

-- 
Len Sorensen
