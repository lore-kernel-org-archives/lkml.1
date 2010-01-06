Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092Ab0AFStd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab0AFStd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 13:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756020Ab0AFStb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 13:49:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:39965 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755808Ab0AFStb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 13:49:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,230,1262592000"; 
   d="scan'208";a="481819489"
Date: Wed, 6 Jan 2010 10:49:26 -0800
From: mark gross <mgross@linux.intel.com>
To: David Brown <davidb@quicinc.com>
Cc: Daniel Walker <dwalker@codeaurora.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Chidambaram, Praveen" <pchidamb@quicinc.com>
Subject: Re: [PATCH] pm_qos: Add QoS param, minimum system bus frequency
Message-ID: <20100106184926.GB21316@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <1262308827-24215-1-git-send-email-dwalker@codeaurora.org>
 <20100104213852.GA5031@linux.intel.com>
 <20100104231852.GA29950@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100104231852.GA29950@huya.qualcomm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 04, 2010 at 03:18:52PM -0800, David Brown wrote:
> On Mon, Jan 04, 2010 at 01:38:52PM -0800, mark gross wrote:
> 
> > Also, on your platform you have a throttling driver controlling the
> > frequency of some bus, that will use this value as a constraint on how
> > far it will throttle.  no?  I would be interested in seeing this driver
> > sometime.  (I just want to make sure no one bastardizes pm_qos into an
> > operating point thing.  I'm not sure I can justify why but I want to
> > avoid that.)
> 
> We're part of a system with several other devices.  Our driver
> just passes the frequency on as our voted minimum.
> 
> Look for PM_QOS_SYSTEM_BUS_FREQ in the file:
> 
>   https://www.codeaurora.org/gitweb/quic/la/?p=kernel/msm.git;a=blob;f=arch/arm/mach-msm/clock.c;h=3a22b5abb8e8acf876367dc6c013fe507af9c0ac;hb=287d333b03df8faafd3a480abc8e121110870839
> 
>   http://tinyurl.com/ye7eg33
hurray for tinyurls!

It looks pretty ok to me on my initial inspection.

--mgross
 
> David
