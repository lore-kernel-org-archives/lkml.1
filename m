Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbYI2J3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbYI2J3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 05:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYI2J3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 05:29:05 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:36992 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbYI2J3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 05:29:04 -0400
X-IronPort-AV: E=Sophos;i="4.33,330,1220241600"; 
   d="scan'208";a="21762748"
Date: Mon, 29 Sep 2008 10:28:55 +0100
From: Tim Deegan <Tim.Deegan@citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: akataria@vmware.com, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>,
       "Jun.Nakajima@Intel.Com" <Jun.Nakajima@Intel.Com>
Subject: Re: Use CPUID to communicate with the hypervisor.
Message-ID: <20080929092855.GK3776@york.uk.xensource.com>
References: <1222472815.29886.43.camel@alok-dev1> <48DD860C.50809@goop.org> <1222485079.23825.13.camel@alok-dev1> <48DF0F8D.3070302@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <48DF0F8D.3070302@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 29 Sep 2008 09:29:01.0852 (UTC) FILETIME=[CEF3EDC0:01C92215]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 22:01 -0700 on 27 Sep (1222552861), Jeremy Fitzhardinge wrote:
> Alok Kataria wrote:
>>> I think there's a move towards doing a scan for a signature, such as
>>> checking every 16 leaves after 0x40000000 for "a while" looking for
>>> interesting signatures, so that a hypervisor can support multiple ABIs
>>> at once.  Given this, it would be better to define a "Generic Hypervisor
>>> ABI" signature, and put all the related leaves together.
>>
>> Hmm interesting, do you have any pointers to this ?
>
> No.  I think I saw a passing reference from Tim Deegan to it, but I
> couldn't find it again when I looked.

I was talking about checking every 256 leaves from 0x40000000, but I
can't remember where I heard it.  The only relevant reference I can
find is the MS hypervisor interface spec's description of leaf
0x40000001: "Hypervisor vendor-neutral interface identification.  This
determines the semantics of the leaves from 0x40000002 through
0x400000FF"

Cheers,

Tim.

-- 
Tim Deegan <Tim.Deegan@citrix.com>
Principal Software Engineer, Citrix Systems (R&D) Ltd.
[Company #02300071, SL9 0DZ, UK.]
