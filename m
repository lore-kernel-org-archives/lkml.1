Return-Path: <linux-kernel-owner+w=401wt.eu-S1756583AbYHGRXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbYHGRXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbYHGRXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:23:04 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63909 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbYHGRXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:23:02 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5356"; a="5231761"
Message-ID: <489B2F73.1010702@qualcomm.com>
Date: Thu, 07 Aug 2008 10:22:59 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: Li Zefan <lizf@cn.fujitsu.com>, mingo@elte.hu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Resurect proper handling of maxcpus= kernel option
References: <1218052854-5020-1-git-send-email-Krasnyansky@qualcomm.com>	 <489A7359.8090607@cn.fujitsu.com> <b6a2187b0808062248m3f26caa5qbee477b489095985@mail.gmail.com>
In-Reply-To: <b6a2187b0808062248m3f26caa5qbee477b489095985@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Chua wrote:
> On Thu, Aug 7, 2008 at 12:00 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> I booted my 2-core x86_32 box with maxcpus=1, and saw cpu1 was offline,
> 
> Test on Lenovo X60s (CoreDuo) 2 CPUs with maxcpus=1, and Dell R900
> (Xeon QuadCore x4) 16 CPUs with maxcpus=8.
> 
> All working. I can switch online and offline up to 2CPUs on X60s, and
> 16CPUs on R900.
> 
>> and then I got softlockup BUG immediately when I onlined cpu1:
> 
> I'm using latest linux kernel.

Excellent.

Andrew, Ingo, can one of you guys please push this patch to mainline.

Thanx
Max

