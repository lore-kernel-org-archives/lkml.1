Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbXC0PbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbXC0PbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 11:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbXC0PbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 11:31:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:37570 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890AbXC0PbS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 11:31:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,335,1170662400"; 
   d="scan'208"; a="64683282:sNHT19011591"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table
Date: Tue, 27 Mar 2007 08:31:09 -0700
Message-ID: <08FE5CC30C9A3F41BF819A502CF7BF6EF97F5E@fmsmsx411.amr.corp.intel.com>
In-Reply-To: <20070327152557.GC7157@colo.lackof.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table
Thread-Index: AcdwhEUihfJkMcumRv6jQMEJbN5hFAAADXfg
From: "Williams, Mitch A" <mitch.a.williams@intel.com>
To: "Grant Grundler" <grundler@parisc-linux.org>
Cc: <linux-pci@atrey.karlin.mff.cuni.cz>, <gregkh@suse.de>,
       <ebiederm@xmission.com>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
X-OriginalArrivalTime: 27 Mar 2007 15:31:10.0458 (UTC) FILETIME=[F23015A0:01C77084]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler wrote: 

>Why wouldn't MSI have the same problems as MSI-X?
>

Because enabling and disabling the MSI interrupt is done through
config space, and config space writes are not posted.  So we won't
see the problem that we do with MSI-X.

-Mitch
