Return-Path: <linux-kernel-owner+w=401wt.eu-S1759434AbZFZRSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434AbZFZRSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 13:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbZFZRSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 13:18:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:5198 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbZFZRSr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 13:18:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,297,1243839600"; 
   d="scan'208";a="528124921"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>,
       "Brown, Len" <len.brown@intel.com>, "Tang, Feng" <feng.tang@intel.com>
Date: Fri, 26 Jun 2009 10:18:50 -0700
Subject: RE: [PATCH 9/9] x86/apic: support moorestown interrupt subsystem
Thread-Topic: [PATCH 9/9] x86/apic: support moorestown interrupt subsystem
Thread-Index: Acn2LMViSOIjpnDrTHSmuNm9e07V/AAVRaQA
Message-ID: <43F901BD926A4E43B106BF17856F0755641A44CB@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07556412B7E8@orsmsx508.amr.corp.intel.com>
 <20090626070720.GB14078@elte.hu>
In-Reply-To: <20090626070720.GB14078@elte.hu>
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

>> -#ifdef CONFIG_ACPI
>> +#if defined(CONFIG_ACPI) || defined(CONFIG_SFI)
>
>Please add a new helper non-interactive Kconfig symbol instead of
>increasing the #ifdef jungle.
>
[[JPAN]] I agreed, maybe this should be part of the SFI patch or already have similar plans?
