Return-Path: <linux-kernel-owner+w=401wt.eu-S933792AbXIBHN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933792AbXIBHN6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 03:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbXIBHNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 03:13:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:55706 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792AbXIBHNs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 03:13:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,198,1186383600"; 
   d="scan'208";a="292204712"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 2.6.23-rc5] driver/char/hpet.c: remove clocksourcewarning on !IA64
Date: Sun, 2 Sep 2007 00:13:45 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A024F3CB9@scsmsx411.amr.corp.intel.com>
In-reply-to: <1188679097.11196.15.camel@dhcp193.mvista.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.23-rc5] driver/char/hpet.c: remove clocksourcewarning on !IA64
Thread-Index: Acfs2X8Sqy8H72wNQyOHOK308RyUHQAVhZIg
References: <20070901155140.972420930@mvista.com> <1188679097.11196.15.camel@dhcp193.mvista.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Daniel Walker" <dwalker@mvista.com>, <torvalds@linux-foundation.org>
Cc: "Bob Picco" <bob.picco@hp.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 Sep 2007 07:13:48.0255 (UTC) FILETIME=[CE8786F0:01C7ED30]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch eliminates the warnings when the clocksoure isn't used.
> It also removes some other unused stuff that goes along with the
> clocksource ..
>
> I don't have access to an ia64 machine, or even a compiler .. So this
> one is untested for that. I'm hoping one of the ia64 guys can help
> test this

Well, it does *compile* cleanly for ia64 [none of my test systems actually
have a functional HPET ... the closest I get is one that fails the hd_nirqs
part of the "if (!data.hd_address || !data.hd_nirqs) {" test in hpet_acpi_add].

Bob: Does this work for you?

-Tony
