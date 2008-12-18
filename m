Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752675AbYLRRQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbYLRRQU (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 12:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbYLRRQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 12:16:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:9483 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbYLRRQD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 12:16:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,244,1228118400"; 
   d="scan'208";a="372021966"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hugh@veritas.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 18 Dec 2008 09:16:39 -0800
Subject: RE: [patch 0/7] x86 PAT: v2 - track pfnmap mappings with
	remap_pfn_range and vm_insert_pfn
Thread-Topic: [patch 0/7] x86 PAT: v2 - track pfnmap mappings with
	remap_pfn_range and vm_insert_pfn
Thread-Index: AclhHVuDD/OMeGKhR9mTilV2WOyuRAAFvp3Q
Message-ID: <7E82351C108FA840AB1866AC776AEC464349A18A@orsmsx505.amr.corp.intel.com>
References: <20081126002157.475142000@intel.com>
 <7E82351C108FA840AB1866AC776AEC464338C11E@orsmsx505.amr.corp.intel.com>
 <20081216195154.GB4501@elte.hu> <20081216220502.GC22722@wotan.suse.de>
 <20081216220746.GE14787@elte.hu> <20081217081932.GC26179@wotan.suse.de>
 <20081218143131.GD9051@elte.hu>
In-Reply-To: <20081218143131.GD9051@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu] 
>Sent: Thursday, December 18, 2008 6:32 AM
>To: Nick Piggin
>Cc: Pallipadi, Venkatesh; Andrew Morton; Hugh Dickins; 
>hpa@zytor.com; tglx@linutronix.de; linux-kernel@vger.kernel.org
>Subject: Re: [patch 0/7] x86 PAT: v2 - track pfnmap mappings 
>with remap_pfn_range and vm_insert_pfn
>
>
>* Nick Piggin <npiggin@suse.de> wrote:
>
>> On Tue, Dec 16, 2008 at 11:07:46PM +0100, Ingo Molnar wrote:
>> > 
>> > * Nick Piggin <npiggin@suse.de> wrote:
>> > > > So when you sent this a month ago i asked the MM folks 
>whether they have 
>> > > > any problems with these patches. Acks (or objections) 
>from Andrew, Nick or 
>> > > > Hugh would be nice to have.
>> > > 
>> > > Last I looked at them, I think all my questions were cleared up.
>> > 
>> > does that transform into a:
>> > 
>> >   Acked-by: Nick Piggin <npiggin@suse.de>
>> 
>> I should think so ;), but I'll take another glance at the next round 
>> after Andrew's comments were incorporated. Are those available?
>
>not yet available - Venki, would you mind to resend the series 
>with those 
>bits fixed, so that Nick can have a look at the end result? Thanks,
>

Yes. Working on it right now and should have it later today..

Thanks,
Venki