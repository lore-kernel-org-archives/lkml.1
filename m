Return-Path: <linux-kernel-owner+w=401wt.eu-S1031385AbXDZSHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031385AbXDZSHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbXDZSHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:07:35 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52419 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754860AbXDZSHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:07:34 -0400
Date: Thu, 26 Apr 2007 11:07:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: David Chinner <dgc@sgi.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <m1k5vzmoo7.fsf@ebiederm.dsl.xmission.com>
Message-ID: <Pine.LNX.4.64.0704261103150.3263@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
 <46303A98.9000605@yahoo.com.au> <20070426063830.GE32602149@melbourne.sgi.com>
 <m1k5vzmoo7.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Eric W. Biederman wrote:

> Ok.  Now why are high end hardware manufacturers building crippled
> hardware?  Or is there only an 8bit field in SCSI for describing
> scatter gather entries?  Although I would think this would be
> move of a controller ranter than a drive issue.

They do not share your definition of "crippled" and would rather 
say that Linux is crippled OS because it cannot support large physical 
block size I/O.

> The change the fundamental fragmentation avoidance algorithm of the
> OS.  Use only one size of page.  That is a huge problem.

No its no problem at all. Its in some peoples head that have never seen it 
done otherwise. We have another OS here that has dealt with variable sized 
pages for ages and our people have been shaking their heads for years 
about these strong opinious that lead us not dealing with the 
problem.


