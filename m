Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbXFOStT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbXFOStT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbXFOStL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:49:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:63773 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbXFOStJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:49:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,425,1175497200"; 
   d="scan'208";a="255013831"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [patch 0/3] no MAX_ARG_PAGES -v2
Date: Fri, 15 Jun 2007 11:49:04 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A01B3467D@scsmsx411.amr.corp.intel.com>
In-Reply-To: <65dd6fd50706151107v784a252aw89a128f255304ef6@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 0/3] no MAX_ARG_PAGES -v2
Thread-Index: AceveAn0dHynRu3bQ0iyVcC4/WynGwABSwPg
From: "Luck, Tony" <tony.luck@intel.com>
To: "Ollie Wild" <aaw@google.com>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Cc: <linux-kernel@vger.kernel.org>, <parisc-linux@lists.parisc-linux.org>,
       <linux-mm@kvack.org>, <linux-arch@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <ak@suse.de>
X-OriginalArrivalTime: 15 Jun 2007 18:49:04.0952 (UTC) FILETIME=[D8FC1380:01C7AF7D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > >   A good heuristic, though, might be to limit
> > > argument size to a percentage (say 25%) of maximum stack size and
> > > validate this inside copy_strings().
> >
> > This seems to do:
>
> Looks good.

Me too.  As I increase the number of arguments, I now have
a smooth cutover from "works" to "Arg list too long", without
the in between zone where the process is killed.

The IA-32 compatability exec path is now working too (I didn't
stress it too hard, but I did try argument lists up to a megabyte).

Acked-by: Tony Luck <tony.luck@intel.com>
