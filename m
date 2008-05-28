Return-Path: <linux-kernel-owner+w=401wt.eu-S1752465AbYE1EFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbYE1EFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 00:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbYE1EFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 00:05:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:60314 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbYE1EFC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 00:05:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,552,1204531200"; 
   d="scan'208";a="333085246"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 2/2] ACPI: add DMI info to enable OSI(Linux) on PRIMEQUEST
Date: Tue, 27 May 2008 21:04:16 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843EC016FF579@orsmsx424.amr.corp.intel.com>
In-Reply-To: <20080527165043.6522f061.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] ACPI: add DMI info to enable OSI(Linux) on PRIMEQUEST
Thread-Index: AcjAVHs3S75t2G+ZTRiiz7fjaBOwKgAIvSeg
References: <4816F9B9.3090609@jp.fujitsu.com><4836660B.3080406@jp.fujitsu.com><483667A4.9000606@jp.fujitsu.com><20080527162029.e549a226.akpm@linux-foundation.org><12c511ca0805271641r68d50d3do9f6427a8dc6ad469@mail.gmail.com> <20080527165043.6522f061.akpm@linux-foundation.org>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <izumi.taku@jp.fujitsu.com>, <linux-acpi@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 28 May 2008 04:05:00.0641 (UTC) FILETIME=[FFDD8D10:01C8C077]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So...  what's the fix?  We don't appear to have a blacklisting table
> under arch/ia64.  Should `#ifdef CONFIG_IA64' be added to
> drivers/acpi/blacklist.c entries?

That sounds reasonable.  We should also put #if defined(CONFIG_X86)
around all the existing entries in the acpi_osi_dmi_table[].

-Tony


