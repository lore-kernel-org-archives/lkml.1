Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbYI2QYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbYI2QYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 12:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYI2QYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 12:24:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:53062 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbYI2QYe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 12:24:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,332,1220252400"; 
   d="scan'208";a="444959324"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: e1000e NVM corruption issue status
Date: Mon, 29 Sep 2008 09:24:32 -0700
Message-ID: <36D9DB17C6DE9E40B059440DB8D95F52064B1603@orsmsx418.amr.corp.intel.com>
In-Reply-To: <alpine.LNX.1.10.0809291817130.4022@jikos.suse.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: e1000e NVM corruption issue status
Thread-Index: AckiT1ji5czPZ7DDSe+RvaB2io63SQAACXRA
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com> <Pine.WNT.4.63.0809251811330.1736@jbrandeb-desk.amr.corp.intel.com> <Pine.WNT.4.63.0809251857360.1736@jbrandeb-desk.amr.corp.intel.com> <Pine.WNT.4.63.0809251913300.1736@jbrandeb-desk.amr.corp.intel.com> <alpine.LNX.1.10.0809291740140.4022@jikos.suse.cz> <alpine.LNX.1.10.0809291817130.4022@jikos.suse.cz>
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Cc: "LKML" <linux-kernel@vger.kernel.org>, <agospoda@redhat.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>,
       "Karsten Keil" <kkeil@suse.de>, "Thomas Gleixner" <tglx@linutronix.de>,
       <chris.jones@canonical.com>, <arjan@linux.jf.intel.com>
X-OriginalArrivalTime: 29 Sep 2008 16:24:33.0896 (UTC) FILETIME=[DB9BEE80:01C9224F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed Karsten's email, apologies for the bounces.

Jiri Kosina wrote:
> We are missing 'break;' after the memset, and that is where the
> hanging machine comes from (the loop keeps spinning forever), right?
> I will verify this right away.

Yep, I think you're right.  I'm almost done prepping our current patch
series, I'll include that fix.  Please let me know if your test shows it
fixes it.
