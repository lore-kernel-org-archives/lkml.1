Return-Path: <linux-kernel-owner+w=401wt.eu-S1765035AbXFFLif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765035AbXFFLif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 07:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbXFFLi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 07:38:28 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59242 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762197AbXFFLi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 07:38:27 -0400
Date: Wed, 6 Jun 2007 17:16:52 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v15
Message-ID: <20070606114652.GB7948@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070531150908.GA23538@elte.hu> <20070606064228.GA22443@in.ibm.com> <20070606070143.GA7375@elte.hu> <20070606074317.GB3274@in.ibm.com> <b647ffbd0706060208i5666f57eoe96215b636617622@mail.gmail.com> <46668E4D.8060206@linux.vnet.ibm.com> <20070606105950.GA32729@in.ibm.com> <b647ffbd0706060419v1ed81e15w312f44aad8975d5b@mail.gmail.com> <20070606113733.GD3274@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606113733.GD3274@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 05:07:33PM +0530, Srivatsa Vaddagiri wrote:
> No, fair_sched_class :: put_prev_task() if we are transitioning from
> NORMAL->RT. That will update the fair_clock based on execution time
> of current task in fair_sched class?

On seconds thoughts, this may not be necessary as the deactivate_task
(from fair_sched class) will accomplish that.

-- 
Regards,
vatsa
