Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbZHTV4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbZHTV4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbZHTV4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:56:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:35163 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbZHTV4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:56:17 -0400
Subject: Re: [PATCH] intel-iommu: Work around yet another BIOS bug
From: David Woodhouse <dwmw2@infradead.org>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Ray Lee <ray-lk@madrabbit.org>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Faidon Liambotis <paravoid@debian.org>,
       Matt Domsch <Matt_Domsch@dell.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       bero@arklinux.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090820214712.GA26360@lackof.org>
References: <bug-14003-10286@http.bugzilla.kernel.org/>
	 <20090819142634.0fc550d1.akpm@linux-foundation.org>
	 <1250754748.8974.17.camel@macbook.infradead.org>
	 <1250755318.8974.26.camel@macbook.infradead.org>
	 <2c0942db0908201229o6ba670ebqda4d7cfc72d0ece8@mail.gmail.com>
	 <1250796740.3311.2.camel@macbook.infradead.org>
	 <20090820214712.GA26360@lackof.org>
Content-Type: text/plain
Date: Thu, 20 Aug 2009 22:54:58 +0100
Message-Id: <1250805298.3311.62.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 15:47 -0600, Grant Grundler wrote:
> 
> Could that be to reserve address space that the "disabled" IOMMU
> might still be responding to?
> 
> Ie the BIOS hides the control registers so the OS won't talk to the
> device but the IOMMU might still attempt to lookup certain address
> ranges.
> 
> I'm more inclined to believe it's sloppiness on the part of the BIOS
> writers but thought this might be an alternative explanation.

Nah, this is just the normal story: "We smoked too much crack and fried
our brains, and we don't do any QA on the crap we write because that
would leave fewer hours in the day for us to service our crack habit".

We _really_ need open source firmware.

Or at _least_ firmware written by competent engineers -- but I think
we've all fairly much given up on that happening by now?

-- 
dwmw2

