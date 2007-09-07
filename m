Return-Path: <linux-kernel-owner+w=401wt.eu-S965024AbXIGHfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965024AbXIGHfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 03:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbXIGHfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 03:35:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:12708 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895AbXIGHfD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 03:35:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,219,1186383600"; 
   d="scan'208";a="127706651"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: 2.6.23-rc4-mm1 build issue: ia64 link error
Date: Fri, 7 Sep 2007 00:34:59 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A025B103D@scsmsx411.amr.corp.intel.com>
In-reply-to: <20070906183546.GA1449@Krystal>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.23-rc4-mm1 build issue: ia64 link error
Thread-Index: AcfwtMHi8biGzO0dTUuT39wqyE2MXQAbFXqA
References: <20070906183546.GA1449@Krystal>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 Sep 2007 07:35:00.0692 (UTC) FILETIME=[9906C140:01C7F121]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> local symbol 0: discarded in section `.exit.text' from arch/ia64/kernel/built-in.o

This usually means that there is a static __exit function (or __devexit etc.)
somewhere in the object being linked.  The error message is pretty unhelpful
in figuring out *where* in the module.  Look at the 'mm' patches that touch
arch/ia64/kernel to see if one of them tinkers with __exit* attributes.

-Tony
