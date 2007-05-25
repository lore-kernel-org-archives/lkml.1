Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbXEYBOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbXEYBOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 21:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbXEYBOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 21:14:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:19835 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbXEYBOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 21:14:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,575,1170662400"; 
   d="scan'208";a="249485137"
Subject: Re: [PATCH 0/7] KVM: Suspend and cpu hotplug fixes
From: Shaohua Li <shaohua.li@intel.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       lhcs-devel@lists.sourceforge.net
In-Reply-To: <1180008615579-git-send-email-avi@qumranet.com>
References: <1180008615579-git-send-email-avi@qumranet.com>
Content-Type: text/plain
Date: Fri, 25 May 2007 09:10:32 +0800
Message-Id: <1180055432.9919.3.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-24 at 20:10 +0800, Avi Kivity wrote:
> The following patchset makes kvm more robust wrt cpu hotunplug, and
> makes suspend-to-ram actually work.  Suspend-to-disk benefits from
> the cpu hotunplug improvements as well.
> 
> The major issue is that KVM wants to disable the virtualization
> extensions at a point in time when no user processes are schedulable
> on the victim cpu.  No current notifier exists, so a new one,
> CPU_DYING,
> is added for the purpose.
> 
> Should there be no objections, I will submit this patchset for
> inclusion
> in 2.6.22, and backport it to 2.6.21.stable.
Is it possible disabling kvm can be done at the begining of play_dead?
take_cpu_done is designed to run fast.

Thanks,
Shaohua
