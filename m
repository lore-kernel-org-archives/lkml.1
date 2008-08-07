Return-Path: <linux-kernel-owner+w=401wt.eu-S1756359AbYHGRg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359AbYHGRg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbYHGRgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:36:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:58999 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbYHGRgp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:36:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,321,1215414000"; 
   d="scan'208";a="31046520"
From: "Luck, Tony" <tony.luck@intel.com>
To: Joerg Roedel <joerg.roedel@amd.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 7 Aug 2008 10:36:36 -0700
Subject: RE: [PATCH 0/3] make swiotlb prototypes generic
Thread-Topic: [PATCH 0/3] make swiotlb prototypes generic
Thread-Index: Acj4jn3tvTF400gaTVSpKvWmDWHCxAAJVeCA
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3083841F6@orsmsx505.amr.corp.intel.com>
References: <1218114409-20806-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1218114409-20806-1-git-send-email-joerg.roedel@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> this small series of patches introduce a generic header file for the software
> IO/TLB implementation in lib/swiotlb.c. Currently each architecture using this
> code defines the prototypes itself. The prototypes are moved to
> include/linux/swiotlb.h and this file is included in architecture specific code
> for X86 and IA64. The changes are compile tested for both architectures.

Boot tested on ia64 (using generic_defconfig, tiger_defconfig and zx1_defconfig).

-Tony
