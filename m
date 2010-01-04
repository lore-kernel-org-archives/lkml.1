Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087Ab0ADXTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0ADXTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 18:19:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037Ab0ADXTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 18:19:05 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20939 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab0ADXTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 18:19:04 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5851"; a="31364859"
X-IronPort-AV: E=Sophos;i="4.47,500,1257148800"; 
   d="scan'208";a="28620750"
Date: Mon, 4 Jan 2010 15:18:52 -0800
From: David Brown <davidb@quicinc.com>
To: mark gross <mgross@linux.intel.com>
Cc: Daniel Walker <dwalker@codeaurora.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Brown, David" <davidb@quicinc.com>,
       "Chidambaram, Praveen" <pchidamb@quicinc.com>
Subject: Re: [PATCH] pm_qos: Add QoS param, minimum system bus frequency
Message-ID: <20100104231852.GA29950@huya.qualcomm.com>
References: <1262308827-24215-1-git-send-email-dwalker@codeaurora.org>
 <20100104213852.GA5031@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100104213852.GA5031@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 04, 2010 at 01:38:52PM -0800, mark gross wrote:

> Also, on your platform you have a throttling driver controlling the
> frequency of some bus, that will use this value as a constraint on how
> far it will throttle.  no?  I would be interested in seeing this driver
> sometime.  (I just want to make sure no one bastardizes pm_qos into an
> operating point thing.  I'm not sure I can justify why but I want to
> avoid that.)

We're part of a system with several other devices.  Our driver
just passes the frequency on as our voted minimum.

Look for PM_QOS_SYSTEM_BUS_FREQ in the file:

  https://www.codeaurora.org/gitweb/quic/la/?p=kernel/msm.git;a=blob;f=arch/arm/mach-msm/clock.c;h=3a22b5abb8e8acf876367dc6c013fe507af9c0ac;hb=287d333b03df8faafd3a480abc8e121110870839

  http://tinyurl.com/ye7eg33

David
