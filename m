Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbYI2Jot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbYI2Jot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 05:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbYI2Jol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 05:44:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53899 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbYI2Jok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 05:44:40 -0400
Message-ID: <48E0A36D.1010400@redhat.com>
Date: Mon, 29 Sep 2008 12:44:13 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Tim Deegan <Tim.Deegan@citrix.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, akataria@vmware.com,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>,
       "Jun.Nakajima@Intel.Com" <Jun.Nakajima@Intel.Com>
Subject: Re: Use CPUID to communicate with the hypervisor.
References: <1222472815.29886.43.camel@alok-dev1> <48DD860C.50809@goop.org> <1222485079.23825.13.camel@alok-dev1> <48DF0F8D.3070302@goop.org> <20080929092855.GK3776@york.uk.xensource.com>
In-Reply-To: <20080929092855.GK3776@york.uk.xensource.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Deegan wrote:
> I was talking about checking every 256 leaves from 0x40000000, but I
> can't remember where I heard it.  The only relevant reference I can
> find is the MS hypervisor interface spec's description of leaf
> 0x40000001: "Hypervisor vendor-neutral interface identification.  This
> determines the semantics of the leaves from 0x40000002 through
> 0x400000FF"
>
>   

This was discussed at the virtualization mini summit (can't remember who 
brought it up).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

