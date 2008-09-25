Return-Path: <linux-kernel-owner+w=401wt.eu-S1755129AbYIYWWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbYIYWWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 18:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbYIYWWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 18:22:42 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:60526 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752986AbYIYWWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 18:22:41 -0400
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
From: Zachary Amsden <zach@vmware.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alok Kataria <akataria@vmware.com>, Alok kataria <alokkataria1@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Yan Li <elliot.li.tech@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
       "rjmaomao@gmail.com" <rjmaomao@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Daniel Hecht <dhecht@vmware.com>
In-Reply-To: <48DC09D9.7040204@zytor.com>
References: <20080221115452.GB13948@elte.hu>
	 <20080907234510.GA24133@yantp.cn.ibm.com>	 <20080908140423.GG11993@elte.hu>
	 <35f686220809241928k3669e30bi8a98b440443c4bff@mail.gmail.com>
	 <48DB15DB.8040501@zytor.com> <1222317978.23524.117.camel@alok-dev1>
	 <48DB1984.8020704@zytor.com> <1222318928.23524.121.camel@alok-dev1>
	 <48DB1BCE.2070106@zytor.com>  <1222320201.23524.135.camel@alok-dev1>
	 <1222375694.27056.179.camel@bodhitayantram.eng.vmware.com>
	 <48DC09D9.7040204@zytor.com>
Content-Type: text/plain
Date: Thu, 25 Sep 2008 15:20:54 -0700
Message-Id: <1222381254.27056.194.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-25 at 14:59 -0700, H. Peter Anvin wrote:

> However, it is the particular use of this for detection use that is
> utterly damning.  Using random I/O port probes for hardware detect
> should have disappeared in the early 1990's, and it's really disturbing
> that virtualization vendors -- not just VMWare -- are, in effect,
> re-making all the mistakes hardware vendors did in the 1980's.

It's not disturbing, it's expected.  Re-using old broken solutions happens all the time, they can be perfectly valid in some contexts.  The problem is that they tend to live on and evolve into a larger context where they break again.  Surely we can do better, but how to do that isn't always clear-cut.  DMI is a pretty good standard for this, but it still doesn't solve the problem in all contexts (userspace apps).

Zach

