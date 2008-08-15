Return-Path: <linux-kernel-owner+w=401wt.eu-S1759815AbYHOP3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759815AbYHOP3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbYHOP3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:29:07 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:10515 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbYHOP3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:29:06 -0400
X-BigFish: VPS-15(zz1432R98dR936eQ4015M1805Mzz10d3izzz32i6bh87il43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K5NEZY-01-S22-01
Date: Fri, 15 Aug 2008 09:29:48 -0600
From: Jordan Crouse <jordan.crouse@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>,
       Andres Salomon <dilinger@debian.org>,
       linux-geode@bombadil.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: geode-mfgpt: check IRQ before using MFGPT as clocksource
Message-ID: <20080815152948.GB30024@cosmic.amd.com>
References: <48916864.901@LiPPERTEmbedded.de> <20080731143635.GA12585@cosmic.amd.com> <48932ACD.3080805@LiPPERTEmbedded.de> <20080801160026.GB19184@cosmic.amd.com> <4896F8B0.80209@LiPPERTEmbedded.de> <20080815151136.GF10029@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080815151136.GF10029@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 15 Aug 2008 15:28:27.0002 (UTC) FILETIME=[9031EDA0:01C8FEEB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/08/08 17:11 +0200, Ingo Molnar wrote:
> 
> * Jens Rottmann <JRottmann@LiPPERTEmbedded.de> wrote:
> 
> > Adds a simple IRQ autodetection to the AMD Geode MFGPT driver, and 
> > more importantly, adds some checks, if IRQs can actually be received 
> > on the chosen line.  This fixes cases where MFGPT is selected as 
> > clocksource though not producing any ticks, so the kernel simply 
> > starves during boot.
> 
> i've applied it to tip/x86/geode. Should it go into v2.6.27 via 
> x86/urgent, or should wait for v2.6.28?

It fixes a real system hang for some folks, so 2.6.27 would be great
if you and Linus agree. 

Thanks,
Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.

