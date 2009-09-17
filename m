Return-Path: <linux-kernel-owner+w=401wt.eu-S1753621AbZIQFyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbZIQFyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 01:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZIQFyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 01:54:54 -0400
Received: from mga05.intel.com ([192.55.52.89]:22874 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753291AbZIQFyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 01:54:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,401,1249282800"; 
   d="scan'208";a="494268687"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Xen-devel] [RFC][PATCH 07/10] xen/hybrid: Add PV timer support
Date: Thu, 17 Sep 2009 13:54:51 +0800
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; x86_64; ; )
Cc: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "xen-devel" <xen-devel@lists.xensource.com>,
       Eddie Dong <eddie.dong@intel.com>, linux-kernel@vger.kernel.org,
       Jun Nakajima <jun.nakajima@intel.com>
References: <1253090551-7969-1-git-send-email-sheng@linux.intel.com> <1253090551-7969-8-git-send-email-sheng@linux.intel.com> <4AB149BA.1000106@goop.org>
In-Reply-To: <4AB149BA.1000106@goop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909171354.52543.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 September 2009 04:25:30 Jeremy Fitzhardinge wrote:
> On 09/16/09 01:42, Sheng Yang wrote:
> > If we have event channel, we can use VIRQ_TIMER to deliver timer
> > interrupt, otherwise we would reuse IRQ0.
>
> What's the purpose of this?  Why can we get a timer virq via event
> channel as usual?  I'm very dubious about having any platform
> interrupts/apic interaction in this code.
>
>     J

Before this patch, we didn't enable event channel for hybrid guest. But I 
think it's reasonable to enable it. Separating the event channel patch into 
two, one for generic usage, and another one QEmu devices. I would try to do 
this.

-- 
regards
Yang, Sheng
