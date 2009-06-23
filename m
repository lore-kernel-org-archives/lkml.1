Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbZFWVFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbZFWVFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbZFWVFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:05:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:32251 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913AbZFWVFK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:05:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,277,1243839600"; 
   d="scan'208";a="468944844"
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>, "Wang, Shane" <shane.wang@intel.com>
Date: Tue, 23 Jun 2009 14:04:55 -0700
Subject: RE: [RFC v5][PATCH 0b/4] intel_txt: Intel(R) Trusted Execution
 Technology support for Linux - Details
Thread-Topic: [RFC v5][PATCH 0b/4] intel_txt: Intel(R) Trusted Execution
 Technology support for Linux - Details
Thread-Index: Acnz4mHaH7gvEwSpSbGyRv9a+dSHjwAYmcxA
Message-ID: <4F65016F6CB04E49BFFA15D4F7B798D9A2A3C1AE@orsmsx506.amr.corp.intel.com>
References: <4A4024B6.2060600@intel.com>
 <20090623101110.60c0974d@lxorguk.ukuu.org.uk>
In-Reply-To: <20090623101110.60c0974d@lxorguk.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
> Sent: Tuesday, June 23, 2009 2:11 AM
>
> Is there a summary of what has changes from RFC v4 ?

-  The monolithic patch was broken into four patches that represent discrete functionality (boot and build, reboot/halt shutdown, Sx shutdown, forcing DMAR on).  An appropriate (and more descriptive) patch description was added to each patch.

-  Small stylistic cleanups (capitalization, comment wording, whitespace, etc.).

-  The code in hwsleep.c that populated the tboot ACPI structures was moved into its own function in tboot.c.

-  Use pr_warning(), pr_info(), pr_debug().

-  Moved some #include's from the middle of tboot.c to the top.

-  Changed the memory type of the tboot shared page from E820_UNUSABLE to E820_RESERVED (really a change to tboot, but requires a change here in the checking code).

And the new patches that I'm about to send have notes in the top indicating their changes from the previous versions.

Joe
