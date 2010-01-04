Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886Ab0ADWCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab0ADWCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 17:02:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801Ab0ADWCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 17:02:13 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38766 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab0ADWCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 17:02:12 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5851"; a="31333904"
Subject: Re: [PATCH] pm_qos: Add QoS param, minimum system bus frequency
From: Daniel Walker <dwalker@codeaurora.org>
To: mgross@linux.intel.com
Cc: linux-kernel@vger.kernel.org, davidb@quicinc.com, pchidamb@quicinc.com
In-Reply-To: <20100104213852.GA5031@linux.intel.com>
References: <1262308827-24215-1-git-send-email-dwalker@codeaurora.org>
	 <20100104213852.GA5031@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jan 2010 14:00:45 -0800
Message-ID: <1262642445.3097.11.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-04 at 13:38 -0800, mark gross wrote:
> On Thu, Dec 31, 2009 at 05:20:27PM -0800, Daniel Walker wrote:
> > From: Praveen Chidambaram <pchidamb@quicinc.com>
> > 
> > In some systems, the system bus speed can be varied, usually
> > based on the current CPU frequency.  However, various device
> > drivers and/or applications may need a faster system bus for I/O
> > even though the CPU itself may be idle
> 
> What happened to the discussion around multiple platforms needing
> multiple bus pm_qos_requirements?  
> 
> Is system bus freq too generic? (I'm worried about the name space)
> Is this ok? (I'm asking linux-pm for input here.)
> On X86 would this be analogous to FSB, Memory, or PCI bus frequencies?
> What will happen when there are two buses each wanting a PM_QOS
> parameter?  Is that a likely scenario?

We can always change the naming in the future, but someone could add a
PM_QOS_MEMORY_BUS_FREQ or PM_QOS_PERIPHERAL_BUS_FREQ in addition to this
one.. Since it's all generic code having generic naming seems fine..

> Also, on your platform you have a throttling driver controlling the
> frequency of some bus, that will use this value as a constraint on how
> far it will throttle.  no?  I would be interested in seeing this driver
> sometime.  (I just want to make sure no one bastardizes pm_qos into an
> operating point thing.  I'm not sure I can justify why but I want to
> avoid that.)

When you say "operating point thing" do you mean you don't want the
frequency adjusted at runtime? You want it set once then move on?

Daniel

