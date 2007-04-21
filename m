Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbXDUEYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbXDUEYJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 00:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754269AbXDUEYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 00:24:09 -0400
Received: from holomorphy.com ([66.93.40.71]:57130 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176AbXDUEYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 00:24:07 -0400
Date: Fri, 20 Apr 2007 21:24:33 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Tong Li <tong.n.li@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Extend Linux to support proportional-share scheduling
Message-ID: <20070421042433.GE2986@holomorphy.com>
References: <Pine.LNX.4.64.0704201111200.18780@tongli.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704201111200.18780@tongli.jf.intel.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 11:30:04AM -0700, Tong Li wrote:
> This patch extends the existing Linux scheduler with support for
> proportional-share scheduling (as a new KConfig option).
> http://www.cs.duke.edu/~tongli/linux/linux-2.6.19.2-trio.patch
> It uses a scheduling algorithm, called Distributed Weighted Round-Robin 
> (DWRR), which retains the existing scheduler design as much as possible, 
> and extends it to achieve proportional fairness with O(1) time complexity 
> and a constant error bound, compared to the ideal fair scheduling 
> algorithm. The code is by no means final and has been only tested on a 
> four-processor dual-core x86-64 system. Rather than focusing on coding 
> issues, the intent of this RFC is to invite discussions on the proposed 
> DWRR algorithm and proportional-share scheduling in general.

Very nice. I think we need this kind of functionality in mainline.


-- wli
