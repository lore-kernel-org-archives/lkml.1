Return-Path: <linux-kernel-owner+w=401wt.eu-S1751542AbXCXAYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbXCXAYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 20:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbXCXAYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 20:24:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:47827 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbXCXAYY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 20:24:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,321,1170662400"; 
   d="scan'208"; a="215245372:sNHT23469495"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.20.3] Flush writes to MSI-X table
Date: Fri, 23 Mar 2007 17:24:23 -0700
Message-ID: <08FE5CC30C9A3F41BF819A502CF7BF6EF55DD2@fmsmsx411.amr.corp.intel.com>
In-Reply-To: <20070323222207.GB22500@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.20.3] Flush writes to MSI-X table
Thread-Index: Acdtmim8Nd3vL51BTPm8vjCvZdxvFwADv7Kg
From: "Williams, Mitch A" <mitch.a.williams@intel.com>
To: "Greg KH" <gregkh@suse.de>, "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <mingo@redhat.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-OriginalArrivalTime: 24 Mar 2007 00:24:22.0862 (UTC) FILETIME=[C57E86E0:01C76DAA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>Well, I'm sure you can agree that it is _very_ late in the 2.6.21
>release cycle to expect to get this in for that kernel.  How about
>waiting for 2.6.22 and if it's a big deal, getting it into the
>2.6.21-stable tree if needed.
>
>So far I have not seen any bug reports that this patch would fix, have
>you?

Well, I've seen several bug reports on this issue -- but they're all
internal to Intel.

However, we do have here a real bug, which shows up on real hardware,
which will be released soon.  Obviously, I can't discuss release
schedules, but "soon" is a good word to use.  You might find out more if
you read The Register (wink, wink).

Given the time frame for release of 2.6.21, I'd be fine with skipping
2.6.20.x, and putting this in 2.6.21.  But we really don't want to wait
for 2.6.22.

I'll take Auke's suggestion and repost this Monday and cc linux-pci and
a slew of other people.

-Mitch
