Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbZKLUop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbZKLUop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 15:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbZKLUol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 15:44:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281AbZKLUoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 15:44:39 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: jens.axboe@oracle.com, LKML <linux-kernel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, mszeredi@suse.de
Subject: Re: Performance regression in IO scheduler still there
References: <20091026172012.GC7233@duck.suse.cz>
	<x49zl7020mr.fsf@segfault.boston.devel.redhat.com>
	<20091111141031.GA21511@duck.suse.cz>
	<x493a4lot31.fsf@segfault.boston.devel.redhat.com>
	<20091112172941.GK14528@duck.suse.cz>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 12 Nov 2009 15:44:02 -0500
In-Reply-To: <20091112172941.GK14528@duck.suse.cz> (Jan Kara's message of
	"Thu, 12 Nov 2009 18:29:41 +0100")
Message-ID: <x49pr7npj71.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> On Wed 11-11-09 12:43:30, Jeff Moyer wrote:
>> Jan Kara <jack@suse.cz> writes:
>> 
>> >   Sadly, I don't see the improvement you can see :(. The numbers are the
>> > same regardless low_latency set to 0:
>> > 2.6.32-rc5 low_latency = 0:
>> > 37.39 36.43 36.51 -> 36.776667 0.434920
>> >   But my testing environment is a plain SATA drive so that probably
>> > explains the difference...
>> 
>> I just retested (10 runs for each kernel) on a SATA disk with no NCQ
>> support and I could not see a difference.  I'll try to dig up a disk
>> that support NCQ.  Is that what you're using for testing?
>   I don't think I am. How do I find out?

Good question.  ;-)  I grep for NCQ in dmesg output and make sure it's
greater than 0/32.  There may be a better way, though.

>>               2.6.29    2.6.32-rc6,low_latency=0
>> ----------------------------------
>> Average:      34.6648   34.4475
>> Pop.Std.Dev.: 0.55523   0.21981
>   Hmm, strange. Miklos Szeredi tried tiobench on his machine and he also
> saw the regression. I'll try to think what could make the difference.

OK, I'll try again.

Cheers,
Jeff
