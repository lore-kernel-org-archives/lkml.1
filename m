Return-Path: <linux-kernel-owner+w=401wt.eu-S934738AbXGSXzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934738AbXGSXzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 19:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758941AbXGSXy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 19:54:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:8237 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762025AbXGSXyy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 19:54:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,558,1175497200"; 
   d="scan'208";a="108024017"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: build fix for x86_64...
Date: Thu, 19 Jul 2007 16:54:51 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A01FA4327@scsmsx411.amr.corp.intel.com>
In-Reply-To: <200707200109.02039.ak@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: build fix for x86_64...
Thread-Index: AcfKWdCWuuqJwtbIRnurtH6ZnpzbnAABby3g
From: "Luck, Tony" <tony.luck@intel.com>
To: "Andi Kleen" <ak@suse.de>, "Arthur Jones" <arthur.jones@qlogic.com>
Cc: "Vasily Tarasov" <vtaras@openvz.org>, <linux-kernel@vger.kernel.org>,
       "Jan Kara" <jack@ucw.cz>, <linux-arch@vger.kernel.org>
X-OriginalArrivalTime: 19 Jul 2007 23:54:53.0119 (UTC) FILETIME=[3363ACF0:01C7CA60]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Looks good.

Looks good to me too (I'm to blame for the version posted by Doug
that only fixed ia64 ... I didn't take the time to check whether
there was a CONFIG_COMPAT option for x86_64 ... oops).

> Tony, perhaps it would make sense to define some common CONFIG
> for COMPAT_FOR_U64_ALIGNMENT longer term to make the #ifs for this
> case a little less ugly.

Certainly if there is ever a third architecture that needs this the
#if mess will be beyond bad.  But with only the two of us we'd trade
one ugly #ifdef line here for another half-dozen lines in each of
our Kconfig files to define the new term.  I'm not sure whether that
is a win.

-Tony
