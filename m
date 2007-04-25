Return-Path: <linux-kernel-owner+w=401wt.eu-S1423375AbXDYWq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423375AbXDYWq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 18:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423392AbXDYWq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 18:46:26 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:42402 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423375AbXDYWqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 18:46:25 -0400
Subject: Re: [00/17] Large Blocksize Support V3
From: Badari Pulavarty <pbadari@gmail.com>
To: clameter@sgi.com
Cc: lkml <linux-kernel@vger.kernel.org>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <20070424222105.883597089@sgi.com>
References: <20070424222105.883597089@sgi.com>
Content-Type: text/plain
Date: Wed, 25 Apr 2007 15:46:19 -0700
Message-Id: <1177541179.32569.2.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-24 at 15:21 -0700, clameter@sgi.com wrote:
> V2->V3

Hmm.. It broke ext2 :(

V2 worked fine with the small fix I sent you earlier.
But on V3, I can't run fsx. I see random data showing up.
I will debug, when I get a chance.

Thanks,
Badari

READ BAD DATA: offset = 0x5092a4, size = 0x5093a0, fname = (null)
OFFSET  GOOD    BAD     RANGE
0x77f466d0      0x77e1f7c0      0x0000  0x  6ef
operation# (mod 256) for the bad data may be 5284080
0x2820236e      0x77e1f7c0      0x0000  0x  6f1
operation# (mod 256) for the bad data may be 5284080
0x2820236e      0x77e1f7c0      0x0000  0x  6f1
operation# (mod 256) for the bad data may be 5284080
0x2820236e      0x77e1f7c0      0x0000  0x  6f3
operation# (mod 256) for the bad data may be 5284080
0x2820236e      0x77e1f7c0      0x0000  0x  6f3
operation# (mod 256) for the bad data may be 5284080
0x2820236e      0x77e1f7c0      0x0000  0x  6f5
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x776f6e6b      0x6b636568      0x0000  0x  84f
operation# (mod 256) for the bad data may be 5284080
0x2820236e      0x77e1f7c0      0x0000  0x  851
operation# (mod 256) for the bad data may be 5284080
0x2820236e      0x77e1f7c0      0x0000  0x  851
operation# (mod 256) for the bad data may be 5284080
0x2820236e      0x77e1f7c0      0x0000  0x  853
operation# (mod 256) for the bad data may be 5284080
0x2820236e      0x77e1f7c0      0x0000  0x  853
operation# (mod 256) for the bad data may be 5284080
0x2820236e      0x77e1f7c0      0x0000  0x  855
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
0x776f6e6b      0x6b636568      0x0000  0x  857
operation# (mod 256) for the bad data may be 5284080
0x2820236e      0x77e1f7c0      0x0000  0x  859
operation# (mod 256) for the bad data may be 5284080
0x2820236e      0x77e1f7c0      0x0000  0x  859
operation# (mod 256) for the bad data may be 5284080
0x2820236e      0x77e1f7c0      0x0000  0x  85b
operation# (mod 256) for the bad data may be 5284080
LOG DUMP (49149 total operations):
0(2012505808 mod 256): WRITE    0x77f466d0 thru 0x77e1f7c0      (0x0
bytes) HOL***WWWW
0(2012505808 mod 256): WRITE    0x77f466d0 thru 0x77e1f7c0      (0x0
bytes)
0(2012505808 mod 256): READ     0x77f466d0 thru 0x77e1f7c0      (0x0
bytes)
0(2012505808 mod 256): READ     0x77f466d0 thru 0x77e1f7c0      (0x0
bytes)    ***RRRR***


