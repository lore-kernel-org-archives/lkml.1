Return-Path: <linux-kernel-owner+w=401wt.eu-S935043AbXLNWkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935043AbXLNWkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 17:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934580AbXLNWgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 17:36:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58086 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934270AbXLNWgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 17:36:31 -0500
Message-ID: <47630462.6040203@zytor.com>
Date: Fri, 14 Dec 2007 14:32:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Dave Airlie <airlied@skynet.ie>, venkatesh.pallipadi@intel.com,
       ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, davej@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, akpm@linux-foundation.org,
       arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/12] PAT 64b: PAT support for X86_64
References: <20071213235543.568682000@intel.com>	 <alpine.DEB.0.82.0712140023550.27550@skynet.skynet.ie>	 <20071214220015.GD717@linux-os.sc.intel.com> <21d7e9970712141427h25c84e9g76237a93e634fa76@mail.gmail.com>
In-Reply-To: <21d7e9970712141427h25c84e9g76237a93e634fa76@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
> On Dec 15, 2007 8:00 AM, Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:
>> On Fri, Dec 14, 2007 at 12:28:25AM +0000, Dave Airlie wrote:
>>> Yes, the main use for GPUs is to have RAM pages mapped WC, and placed into
>>> a GART on the GPU side, currently for Intel IGD we are okay as the CPU can
>>> access the GPU GART aperture, but other chips exist where this isn't
>>> possible, I think poulsbo and possible some of the AMD IGPs..
>> Ok. So how is it working today on these platforms with no PAT support.
>> Open source drivers use UC or WB on these platforms? As this RAM is not
>> contiguous, one can't use MTRRs to set WC. Right?
>>
>> Well, if WC is needed for RAM, then we have to address it too.
>>
> 
> It doesn't work really, which is mostly the problem :)
> 
> We mostly use UC on these pages, or WB within cache coherent domains.
> mtrrs are totally useless in this situation.
> 

In what sense does it not work?

	-hpa
