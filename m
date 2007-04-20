Return-Path: <linux-kernel-owner+w=401wt.eu-S1030974AbXDTTU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030974AbXDTTU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 15:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030977AbXDTTU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 15:20:57 -0400
Received: from holomorphy.com ([66.93.40.71]:49662 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030974AbXDTTU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 15:20:57 -0400
Date: Fri, 20 Apr 2007 12:21:15 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@skynet.ie>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 7/8] Enhance ramfs to support higher order pages
Message-ID: <20070420192115.GK31925@holomorphy.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com> <20070419163540.11948.51549.sendpatchset@schroedinger.engr.sgi.com> <20070420134226.GA16878@skynet.ie> <20070420144726.GI31925@holomorphy.com> <Pine.LNX.4.64.0704200925160.20232@schroedinger.engr.sgi.com> <20070420171118.GZ2986@holomorphy.com> <Pine.LNX.4.64.0704201012500.20723@schroedinger.engr.sgi.com> <20070420171928.GA2986@holomorphy.com> <Pine.LNX.4.64.0704201051040.20868@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704201051040.20868@schroedinger.engr.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, William Lee Irwin III wrote:
>> Probably just terminological disagreement here. I was referring to
>> allocating the higher-order page from the fault path here, not mapping
>> it or a piece of it with a user pte.

On Fri, Apr 20, 2007 at 10:57:25AM -0700, Christoph Lameter wrote:
> Ah. Okay. I have some dysfunctional patches here that implement mmap 
> support. Would you be willing to take care of that aspect of things? Then 
> I can focus on the other VM pieces. I am going to post them following this 
> message. These are an absolute mess. They do not compile etc etc.

Good stuff. Going over this sounds like more fun than trying to 
preemptively clean up after whichever scheduler trainwreck ends up
hitting mainline.


-- wli
