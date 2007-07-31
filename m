Return-Path: <linux-kernel-owner+w=401wt.eu-S932518AbXGaQos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518AbXGaQos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762993AbXGaQoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:44:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:57947 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757110AbXGaQoi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:44:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,204,1183359600"; 
   d="scan'208";a="256944420"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] flush icache before set_pte take6. [4/4] optimization for cpus other than montecito
Date: Tue, 31 Jul 2007 09:44:35 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A020E3B1C@scsmsx411.amr.corp.intel.com>
In-Reply-To: <ed5aea430707302115h484620f1le51fc054436b273a@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] flush icache before set_pte take6. [4/4] optimization for cpus other than montecito
Thread-Index: AcfTKXykafFKZlDYTWOUDtXzlFiQIwAaBGdQ
From: "Luck, Tony" <tony.luck@intel.com>
To: "David Mosberger-Tang" <dmosberger@gmail.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
       <Zoltan.Menyhart@bull.net>, "Christoph Lameter" <clameter@sgi.com>
X-OriginalArrivalTime: 31 Jul 2007 16:44:36.0342 (UTC) FILETIME=[14592160:01C7D392]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This seems crazy to me.  Flushing should occur according to the
> *architecture*, not model-by-model.  Even if we happen to get "lucky"
> on pre-Montecito CPUs, that doesn't justify such ugly hacks.  Or you
> really want to debug this *again* come next CPU?

Ditto.  The only reason we should ever have model specific checks should
be to work around model specific errata (e.g. the McKinley Errata #9 code
in patch.c).

-Tony
