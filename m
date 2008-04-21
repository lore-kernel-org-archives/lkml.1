Return-Path: <linux-kernel-owner+w=401wt.eu-S1759875AbYDUUOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875AbYDUUOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 16:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYDUUOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 16:14:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38660 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbYDUUOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 16:14:40 -0400
Message-ID: <480CF4C8.60803@zytor.com>
Date: Mon, 21 Apr 2008 16:10:48 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Adrian Bunk <bunk@kernel.org>, Alexey Starikovskiy <astarikovskiy@suse.de>,
       tglx@linutronix.de, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org
Subject: Re: Voyager phys_cpu_present_map compile error
References: <20080421000238.GD26897@cs181133002.pp.htv.fi> <20080421085314.GI26897@cs181133002.pp.htv.fi> <20080421120054.GA6788@elte.hu> <480C8FD6.3030700@zytor.com> <20080421195517.GH8770@elte.hu> <480CF2F9.4060608@zytor.com> <20080421201129.GL8770@elte.hu>
In-Reply-To: <20080421201129.GL8770@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> Ingo Molnar wrote:
>>> sure - but no need to be rude and mark it BROKEN when we've got this much 
>>> better tool named "email". BROKEN is really just for cases where there's 
>>> no-one willing to fix things.
>> I'm not trying to be rude, I'm just trying to avoid putting an 
>> unnecessary burden on testers and just let Kconfig know not to pick 
>> this particular random path.  Obviously, Kconfig doesn't care, but 
>> it's clear BROKEN has negative associations; besides, it really is 
>> unnecessarily strong.
>>
>> Perhaps what we need is NORAND?
> 
> yep, i was thinking about CONFIG_BROKEN2 already :-)
> 
> then i came up with: CONFIG_NON_GENERIC. All code that can break a 
> normal bootup should be marked with that. Such as CONFIG_ROOT_NFS=y 
> [panics on bootup] or CONFIG_EUROTECH_WDT=y [crashes on bootup] or 
> CONFIG_SND_MTPAV [hangs on bootup] and the dozens of other config 
> options i had to map when trying to bring up an allyesconfig kernel for 
> the first time ;-)
> 
> auto-tests could then still build-test NON_GENERIC kernels but would not 
> attempt to boot them up.
> 

Well, that's slightly different.  I don't think it's fair to impose even 
compile-testing Voyager on the entire x86 development community.

	-hpa

