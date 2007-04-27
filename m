Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbXD0Abz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbXD0Abz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 20:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256AbXD0Abz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 20:31:55 -0400
Received: from holomorphy.com ([66.93.40.71]:54470 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240AbXD0Aby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 20:31:54 -0400
Date: Thu, 26 Apr 2007 17:32:16 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070427003216.GM19966@holomorphy.com>
References: <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com> <46304C74.9040304@yahoo.com.au> <Pine.LNX.4.64.0704260003450.30731@schroedinger.engr.sgi.com> <46305177.7060102@yahoo.com.au> <Pine.LNX.4.64.0704260017430.31003@schroedinger.engr.sgi.com> <463057D9.9030804@yahoo.com.au> <20070426145310.GH19966@holomorphy.com> <m1ejm7kndn.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ejm7kndn.fsf@ebiederm.dsl.xmission.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III <wli@holomorphy.com> writes:
>> In memory as on disk, contiguity matters a lot for performance.

On Thu, Apr 26, 2007 at 12:21:24PM -0600, Eric W. Biederman wrote:
> Not nearly so much though.  In memory you don't have seeks to avoid.
> On disks avoiding seeks is everything.

I readily concede that seeks are most costly. Yet memory contiguity
remains rather influential.

Witness the fact that I'm now being called upon a second time to
adjust the order in which mm/page_alloc.c returns pages for the
sake of implicitly establishing IO contiguity (or otherwise
determining why things are coming out backward now).


-- wli
