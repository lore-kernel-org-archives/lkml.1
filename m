Return-Path: <linux-kernel-owner+w=401wt.eu-S1760938AbXERUh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760938AbXERUh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 16:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbXERUhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 16:37:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:2545 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbXERUhM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 16:37:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,553,1170662400"; 
   d="scan'208";a="229647268"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [rfc] increase struct page size?!
Date: Fri, 18 May 2007 13:37:09 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A017BCA67@scsmsx411.amr.corp.intel.com>
In-Reply-To: <Pine.LNX.4.64.0705181112250.11881@schroedinger.engr.sgi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [rfc] increase struct page size?!
Thread-Index: AceZeoNJ7tx1uS1mS9eY9DH1jiKQeAAETzgg
From: "Luck, Tony" <tony.luck@intel.com>
To: "Christoph Lameter" <clameter@sgi.com>, "Nick Piggin" <npiggin@suse.de>
CC: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux Memory Management List" <linux-mm@kvack.org>,
       <linux-arch@vger.kernel.org>
X-OriginalArrivalTime: 18 May 2007 20:37:10.0712 (UTC) FILETIME=[4F3B8380:01C7998C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I wonder if there are other uses for the free space?

	unsigned long moreflags;

Nick and Hugh were just sparring over adding a couple (or perhaps 8)
flag bits.  This would supply 64 new bits ... maybe that would keep
them happy for a few more years.

-Tony
