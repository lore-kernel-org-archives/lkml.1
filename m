Return-Path: <linux-kernel-owner+w=401wt.eu-S1422653AbXC2WB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422653AbXC2WB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 18:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422656AbXC2WB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 18:01:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:15844 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422653AbXC2WB6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 18:01:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,348,1170662400"; 
   d="scan'208"; a="66084746:sNHT2404594872"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table (rev 2)
Date: Thu, 29 Mar 2007 15:01:39 -0700
Message-ID: <08FE5CC30C9A3F41BF819A502CF7BF6EFCDB1B@fmsmsx411.amr.corp.intel.com>
In-Reply-To: <m1hcs4j88u.fsf@ebiederm.dsl.xmission.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table (rev 2)
Thread-Index: AcdyI8EWr+xXqCC/Ts29yVrTmNCt8gAKdKgQ
From: "Williams, Mitch A" <mitch.a.williams@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <linux-pci@atrey.karlin.mff.cuni.cz>, <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
X-OriginalArrivalTime: 29 Mar 2007 22:01:40.0832 (UTC) FILETIME=[D49AEE00:01C7724D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:

>Do we still need the flush the set affinity routines?
>Shouldn't flush in mask and unmask should now be enough?

Yeah, I think you're right.  I've removed that call, and 
we're running some basic validation on the change.  I'll
post a new patch tomorrow AM.
-Mitch
