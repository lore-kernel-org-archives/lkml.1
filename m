Return-Path: <linux-kernel-owner+w=401wt.eu-S1757793AbZDFV1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793AbZDFV1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbZDFV1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:27:13 -0400
Received: from rtr.ca ([76.10.145.34]:55680 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538AbZDFV1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:27:12 -0400
Message-ID: <49DA73AE.5020106@rtr.ca>
Date: Mon, 06 Apr 2009 17:27:10 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Jeff Moyer <jmoyer@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tytso@mit.edu, drees76@gmail.com,
       jesper@krogh.cc, linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: Linux 2.6.29
References: <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090401143622.b1885643.akpm@linux-foundation.org> <20090402010044.GA16092@elte.hu> <20090403040649.GF3795@csclub.uwaterloo.ca> <x49myaxjrsb.fsf@segfault.boston.devel.redhat.com> <20090406141516.GM3795@csclub.uwaterloo.ca>
In-Reply-To: <20090406141516.GM3795@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Fri, Apr 03, 2009 at 06:28:36PM -0400, Jeff Moyer wrote:
>> Could you try one more test, please?  Switch back to CFQ and set
>> /sys/block/sdX/queue/iosched/slice_idle to 0?
> 
> I actually am running cfq at the moment, but with Mark's (I think it
> was) preload library to change fsync calls to at most one per 5 seconds
> instead of 10 per second.  So far that has certainly made things a lot
> better as far as I can tell.  Maybe not as good as anticipatory seemed
> to be but certainly better.
> 
> I can try your suggestion too.
..

Yeah, I think the sync_file_range() patch is the way to go.
It seems to be smooth enough here with four or five simultaneous recordings,
a couple of commflaggers, and an HD playback all happening at once.

Cheers
