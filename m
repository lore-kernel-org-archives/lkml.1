Return-Path: <linux-kernel-owner+w=401wt.eu-S1761945AbYA3Qfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761945AbYA3Qfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 11:35:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760318AbYA3QfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 11:35:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:45837 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760852AbYA3QfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 11:35:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,278,1199692800"; 
   d="scan'208";a="294378373"
Message-ID: <47A0A713.7030304@intel.com>
Date: Wed, 30 Jan 2008 08:34:27 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: andi@lisas.de
CC: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, bunk@kernel.org
Subject: Re: [RFC/PATCH] e100 driver didn't support any MII-less PHYs...
References: <20071228235118.GA31059@rhlx01.hs-esslingen.de> <477732A5.5020501@intel.com> <20080101200908.GA14805@rhlx01.hs-esslingen.de> <20080129230315.GA13389@rhlx01.hs-esslingen.de> <479FB225.7090604@intel.com> <20080130064909.GA19793@rhlx01.hs-esslingen.de>
In-Reply-To: <20080130064909.GA19793@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jan 2008 16:35:15.0250 (UTC) FILETIME=[17818920:01C8635E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Mohr wrote:
> Hi,
> 
> On Tue, Jan 29, 2008 at 03:09:25PM -0800, Kok, Auke wrote:
>> Andreas Mohr wrote:
>>> Perhaps it's useful to file a bug/patch
>>> on http://sourceforge.net/projects/e1000/ ? Perhaps -mm testing?
>> I wanted to push this though our testing labs first which has not happened due to
>> time constraints - that should quickly at least confirm that the most common nics
>> work OK after the change with your patch. I'll try and see if we can get this
>> testing done soon.
> 
> Oh, full-scale regression testing even? Nice idea...
> Would optionally be even better if during hardware tests one could also
> dig out some i82503-based card (or additional MII-less cards?)
> since I didn't really make any effort yet to try to make them all
> recognized/supported by my patch already (would have been out of scope anyway
> since I have this single card only).

the problem is that I think that most of those (mii-less cards) are customly
designed by OEM's that buy the silicon and glue on a different interface and we
usually do not carry those designs in our labs apart from a few exceptions. So, I
can at least touch the common hardware in testing, but not the exotic stuff.

Auke

