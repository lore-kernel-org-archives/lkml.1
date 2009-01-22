Return-Path: <linux-kernel-owner+w=401wt.eu-S1759668AbZAVW4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759668AbZAVW4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759513AbZAVW4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:56:21 -0500
Received: from mga03.intel.com ([143.182.124.21]:45557 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759435AbZAVW4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:56:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,308,1231142400"; 
   d="scan'208";a="102930208"
Date: Thu, 22 Jan 2009 14:56:18 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Andi Kleen <andi@firstfloor.org>, Avuton Olrich <avuton@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Fail to early boot with v2.6.27-rc2 to at least v2.6.29-rc2 due to dc1e35c
Message-ID: <20090122225618.GA16033@linux-os.sc.intel.com>
References: <4974CC8B.1030403@zytor.com> <3aa654a40901191131p7c141378m1bcd3baeed098e09@mail.gmail.com> <4974DD86.2090300@zytor.com> <20090119201115.GD31356@linux-os.sc.intel.com> <3aa654a40901191346i12cc736m40bebd422100a088@mail.gmail.com> <20090119215736.GE31356@linux-os.sc.intel.com> <4974F9A8.7060107@zytor.com> <87bpu1dyl6.fsf@basil.nowhere.org> <20090122222250.GI28352@linux-os.sc.intel.com> <4978F5F8.1040103@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4978F5F8.1040103@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 02:40:56PM -0800, H. Peter Anvin wrote:
> Suresh Siddha wrote:
> > Ok. Here is the patch for this aswell. Thanks.
> 
> I wonder if it wouldn't be better to do this in the CPUID code rather
> than in the xsave code...

We can do this in the cpuid code aswell, but the dependency information
varies from feature to feature and there are no architectural methods here.
So I think its better to keep it near the code enabling that feaure.

thanks,
suresh
