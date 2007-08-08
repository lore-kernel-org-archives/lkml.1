Return-Path: <linux-kernel-owner+w=401wt.eu-S935684AbXHHOxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935684AbXHHOxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765676AbXHHOxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:53:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:30612 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761067AbXHHOxp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:53:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,236,1183359600"; 
   d="scan'208";a="115070465"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Introducing paravirt_ops for x86_64
Date: Wed, 8 Aug 2007 07:53:43 -0700
Message-ID: <97D612E30E1F88419025B06CB4CF1BE10326E129@scsmsx412.amr.corp.intel.com>
In-Reply-To: <11865467522495-git-send-email-gcosta@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Introducing paravirt_ops for x86_64
thread-index: AcfZiui69WjRuAQ5RC6WyxK38acLtAAPrVaQ
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       <linux-kernel@vger.kernel.org>
Cc: <lguest@ozlabs.org>, <virtualization@lists.linux-foundation.org>,
       <chrisw@sous-sol.org>, <anthony@codemonkey.ws>,
       <akpm@linux-foundation.org>, <mingo@elte.hu>
X-OriginalArrivalTime: 08 Aug 2007 14:53:44.0403 (UTC) FILETIME=[EAC9CA30:01C7D9CB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> Hi folks,
> 
> After some time away from it, and a big rebase as a consequence, here
is
> the updated version of paravirt_ops for x86_64, heading to inclusion.
> 
> Your criticism is of course, very welcome.
> 
> Have fun

Do you assume that the kernel ougtht to use 2MB pages for its mappings
(e.g. initilal text/data,  direct mapping of physical memory) under your
paravirt_ops?  As far as I look at the patches, I don't find one. 

Jun
---
Intel Open Source Technology Center
