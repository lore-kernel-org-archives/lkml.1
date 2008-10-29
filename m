Return-Path: <linux-kernel-owner+w=401wt.eu-S1755082AbYJ2Uwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbYJ2Uwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 16:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbYJ2Uw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 16:52:28 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:27248 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbYJ2Uw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 16:52:27 -0400
Subject: Re: [PATCH] disable CPU side GART accesses
From: Bob Montgomery <bob.montgomery@hp.com>
Reply-To: bob.montgomery@hp.com
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "vojtech@suse.cz" <vojtech@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "chandru@in.ibm.com" <chandru@in.ibm.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <ak@linux.intel.com>, Dave Jones <davej@redhat.com>
In-Reply-To: <4906495B.1060506@kernel.org>
References: <1224107317.2215.238.camel@amd.troyhebe>
	 <20081015234842.GA10999@elte.hu> <1225147341.2215.401.camel@amd.troyhebe>
	 <4906495B.1060506@kernel.org>
Content-Type: text/plain; charset=UTF-8
Organization: Contractor at HP
Date: Wed, 29 Oct 2008 14:52:44 -0600
Message-Id: <1225313564.3428.14.camel@amd.troyhebe>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 23:06 +0000, Yinghai Lu wrote:
> Bob Montgomery wrote:
> > On Wed, 2008-10-15 at 23:48 +0000, Ingo Molnar wrote:
> >> (Cc:-ed the GART folks.)
> >
> > Are there any objections to this patch?  The problem has been reproduced
> > in 2.6.18 and 2.6.27, so existing changes in the gart code have not
> > addressed it.
> 
> better to have someone with amd system + 8g ram + agp adapter to verify it...
> 
> YH

Good idea.

I don't think HP made a system with opteron and agp, so I haven't found
a system here to test.  But I did see that there have been non-HP
motherboards from several years ago that advertised opteron with agp.
Anyone running that type of system?

The other question is whether AGP graphics on linux for amd64 ever
expected host translation to work, since setting DisGartCpu is turning
off host translation.   

I saw this in the AGP 3.0 spec (hopeful, but inconclusive):

"8. The Core-logic is not required by the AGP specification to translate
   accesses directed to the AGP aperture by a host processor –
   termed host translation. Portable AGP3.0 software should not rely
   upon the existence of host translation."

Any advice from graphics experts?

Bob Montgomery







