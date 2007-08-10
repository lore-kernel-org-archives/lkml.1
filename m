Return-Path: <linux-kernel-owner+w=401wt.eu-S934464AbXHJXdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934464AbXHJXdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 19:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934341AbXHJXcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 19:32:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:34079 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933294AbXHJXco convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 19:32:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,246,1183359600"; 
   d="scan'208";a="116114923"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 9/24] make atomic_read() behave consistently on ia64
Date: Fri, 10 Aug 2007 16:32:42 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A0224C94A@scsmsx411.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 9/24] make atomic_read() behave consistently on ia64
Thread-Index: Acfbn9UhFk01w3aqTHeIYAbo/zeVAgAAM7AQAAFfSJA=
References: <20070809135107.GA15985@shell.boston.redhat.com><617E1C2C70743745A92448908E030B2A02213B3C@scsmsx411.amr.corp.intel.com><46BCC1AF.5050204@redhat.com><617E1C2C70743745A92448908E030B2A0224C777@scsmsx411.amr.corp.intel.com> <jewsw3oyl8.fsf@sykes.suse.de> <617E1C2C70743745A92448908E030B2A0224C88B@scsmsx411.amr.corp.intel.com> <46BCE9F8.4060009@redhat.com> 
From: "Luck, Tony" <tony.luck@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>, "Chris Snook" <csnook@redhat.com>
Cc: "Andreas Schwab" <schwab@suse.de>, <linux-kernel@vger.kernel.org>,
       <linux-arch@vger.kernel.org>, <torvalds@linux-foundation.org>,
       <netdev@vger.kernel.org>, <akpm@linux-foundation.org>, <ak@suse.de>,
       <heiko.carstens@de.ibm.com>, <davem@davemloft.net>,
       <schwidefsky@de.ibm.com>, <wensong@linux-vs.org>, <horms@verge.net.au>,
       <wjiang@resilience.com>, <cfriesen@nortel.com>, <zlynx@acm.org>,
       <rpjday@mindspring.com>, <jesper.juhl@gmail.com>
X-OriginalArrivalTime: 10 Aug 2007 23:32:43.0773 (UTC) FILETIME=[C02012D0:01C7DBA6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Here are the functions in which they occur in the object file. You
> may have to chase down some inlining to find the function that
> actually uses atomic_*().

Ignore this ... Andreas' patch was only two lines so I
thought I'd "save time" by just hand-editing the source over
on my build machine.  I managed to goof that by editing the
wrong  function for one of the cases. :-(

New result.  With Andreas's patch correctly applied, the generated
vmlinux is identical with/without your patch.

-Tony
