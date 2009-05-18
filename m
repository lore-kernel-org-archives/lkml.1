Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbZEROQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbZEROQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 10:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbZEROQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 10:16:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59735 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbZEROQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 10:16:32 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Olga Kornievskaia <aglo@citi.umich.edu>,
       "J. Bruce Fields" <bfields@fieldses.org>, Jim Rees <rees@umich.edu>,
       linux-nfs@vger.kernel.org
Subject: Re: 2.6.30-rc deadline scheduler performance regression for iozone over NFS
References: <x49hc0f79k9.fsf@segfault.boston.devel.redhat.com>
	<20090508120119.8c93cfd7.akpm@linux-foundation.org>
	<20090511081415.GL4694@kernel.dk>
	<x49skjb21b7.fsf@segfault.boston.devel.redhat.com>
	<20090511165826.GG4694@kernel.dk>
	<x494ovp4r51.fsf@segfault.boston.devel.redhat.com>
	<20090512204433.7eb69075.akpm@linux-foundation.org>
	<x49y6t1rqw0.fsf@segfault.boston.devel.redhat.com>
	<x49k54ku7i2.fsf@segfault.boston.devel.redhat.com>
	<1242258338.5407.244.camel@heimdal.trondhjem.org>
	<x49octv7qr8.fsf@segfault.boston.devel.redhat.com>
	<1242311620.6560.14.camel@heimdal.trondhjem.org>
	<x49ws8j686r.fsf@segfault.boston.devel.redhat.com>
	<1242587454.17796.2.camel@heimdal.trondhjem.org>
	<1242587524.17796.3.camel@heimdal.trondhjem.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 18 May 2009 10:15:22 -0400
In-Reply-To: <1242587524.17796.3.camel@heimdal.trondhjem.org> (Trond
	Myklebust's message of "Sun, 17 May 2009 15:12:04 -0400")
Message-ID: <x49tz3ia45h.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <trond.myklebust@fys.uio.no> writes:

> On Sun, 2009-05-17 at 15:11 -0400, Trond Myklebust wrote:
>> On Thu, 2009-05-14 at 11:00 -0400, Jeff Moyer wrote:
>> > Sorry for the previous, stupid question.  I applied the patch in
>> > addition the last one and here are the results:
>> > 
>> > 70327
>> > 71561
>> > 68760
>> > 69199
>> > 65324
>> > 
>> > A packet capture for this run is available here:
>> >   http://people.redhat.com/jmoyer/trond2.pcap.bz2
>> > 
>> > Any more ideas?  ;)
>> 
>> Yep. I've got 2 more patches for you. With both of them applied, I'm
>> seeing decent performance on my own test rig. The first patch is
>> appended. I'll send the second in another email (to avoid attachments).
>
> Here is number 2. It is incremental to all the others...

With all 4 patches applied, these are the numbers for 5 runs:

103168
101212
103346
100842
103172

It's looking much better, but we're still off by a few percent.  Thanks
for the quick turnaround on this, Trond!  If you submit these patches,
feel free to add:

Tested-by: Jeff Moyer <jmoyer@redhat.com>

Cheers,
Jeff
