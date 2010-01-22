Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737Ab0AVBda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab0AVBda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755698Ab0AVBda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:33:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:49850 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676Ab0AVBd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:33:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,321,1262592000"; 
   d="scan'208";a="589372188"
Subject: Re: 2.6.33-rc4-git7 -- head/6104 is trying to acquire lock:
 (cpuidle_lock){+.+.+.}, at: [<c129e2ec>] show_current_governor+0x12/0x4e
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "Li, Shaohua" <shaohua.li@intel.com>, Dave Jones <davej@redhat.com>
In-Reply-To: <20100121191812.GA1840@redhat.com>
References: <a44ae5cd1001210950h34d57a5cq8b484ec4d3dbb48b@mail.gmail.com>
	 <20100121191812.GA1840@redhat.com>
Content-Type: text/plain
Date: Thu, 21 Jan 2010 17:33:25 -0800
Message-Id: <1264124005.16916.301.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-21 at 11:18 -0800, Dave Jones wrote:
> On Thu, Jan 21, 2010 at 12:50:09PM -0500, Miles Lane wrote:
>  > I was scanning the first few characters of all the files in /proc and
>  > /sys.  I will attempt to determine which file(s) triggered this.
> 
> 
> Dropped cpufreq-list from Cc, added cpuidle maintainers.
> While they sound similar, they are unrelated.

Thanks for reporting the problem. I am able to reproduce this locally.
Will followup once I have some time to poke at it a bit more.

Thanks,
Venki



