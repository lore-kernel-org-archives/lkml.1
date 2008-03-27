Return-Path: <linux-kernel-owner+w=401wt.eu-S1761207AbYC0QiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761207AbYC0QiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 12:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760766AbYC0QiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 12:38:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54327 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758565AbYC0QiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 12:38:04 -0400
Message-ID: <47EBCD2A.8010301@zytor.com>
Date: Thu, 27 Mar 2008 09:36:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Huang, Ying" <ying.huang@intel.com>, andi@firstfloor.org,
       mingo@redhat.com, tglx@linutronix.de, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/4] x86_64 boot: Add linked listof struct	setup_data
 to boot protocol
References: <1206601743.3067.20.camel@caritas-dev.intel.com> <20080327083221.GD15626@elte.hu> <1206609936.13404.0.camel@caritas-dev.intel.com> <20080327094759.GB5056@elte.hu>
In-Reply-To: <20080327094759.GB5056@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Huang, Ying <ying.huang@intel.com> wrote:
> 
>>> could you try to do that nevertheless? We generally prefer feature 
>>> patches after sensible unification has been done.
>> I try to port reserve_early() to i386 before. But it is said that the 
>> reserve_early() should be replaced by e820 based early 
>> reservation/allocation mechanism on i386 and x86_64. So I think I 
>> should wait for it.
> 
> correct, e820 space manipulations is how it should be done. Peter, any 
> progress on that project?
> 

It's not all that complex of a piece of code, but the testing is painful 
(fortunately, I have some code which has been at least partially 
validated already.)

I have been working on a nonkernel project this week 
(http://syslinux.zytor.com/archives/2008-March/009723.html), but I'm 
hoping to look at it next week.

	-hpa
