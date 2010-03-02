Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab0CBDYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 22:24:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:53053 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab0CBDYD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 22:24:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,564,1262592000"; 
   d="scan'208";a="600383842"
From: "Dong, Eddie" <eddie.dong@intel.com>
To: Sheng Yang <sheng@linux.intel.com>, Jeremy Fitzhardinge <jeremy@goop.org>
CC: xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       "Dong, Eddie" <eddie.dong@intel.com>
Date: Tue, 2 Mar 2010 11:20:10 +0800
Subject: RE: [Xen-devel] [PATCH 0/7][v4] PV extension of HVM (Hybrid) for Xen
Thread-Topic: [Xen-devel] [PATCH 0/7][v4] PV extension of HVM (Hybrid) for
 Xen
Thread-Index: Acq5p8tFb9J01QPRSaOxOSrdKjAUFAADwiNg
Message-ID: <1A42CE6F5F474C41B63392A5F80372B21D43CEF0@shsmsx501.ccr.corp.intel.com>
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com>
	<4B8C5ED9.1040109@goop.org> <201003020926.03512.sheng@linux.intel.com>
In-Reply-To: <201003020926.03512.sheng@linux.intel.com>
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

> 
>> Also, I'd like to see a clearer statement of what you're specifically
>> trying to optimise for here.  What is inefficient in an unmodified
>> HVM domain, and how do your patches address these things.  What
>> measurements have you made?
> 
> The key issue we want to address is the overhead of LAPIC, especially
> EOI and other actions resulted in explicit vmexit. That is the
> overhead we want to eliminate. And evtchn seems like a perfect choice
> to us. 
> 

That is not complete. Linux timer in HVM is always annoying, and time to time make surprise to endusers. PV timer does help here. Eventchannel is nice to HVM as well. 

Thx, Eddie