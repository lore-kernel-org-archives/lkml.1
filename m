Return-Path: <linux-kernel-owner+w=401wt.eu-S1758454AbZFZNtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454AbZFZNtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 09:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbZFZNs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 09:48:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:52697 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948AbZFZNsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 09:48:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,297,1243839600"; 
   d="scan'208";a="528069056"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 26 Jun 2009 06:48:57 -0700
Subject: RE: [PATCH 9/9] x86/apic: support moorestown interrupt subsystem
Thread-Topic: [PATCH 9/9] x86/apic: support moorestown interrupt subsystem
Thread-Index: Acn2LMViSOIjpnDrTHSmuNm9e07V/AANtBIw
Message-ID: <43F901BD926A4E43B106BF17856F07556412B895@orsmsx508.amr.corp.intel.com>
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

>
>This code is stylistically and structurally challenged and will need
>a lot more work to be acceptable. Please clean it up and abstract
>out the timer driver bits:
>
>The proper solution here is to first introduce a proper abstraction
>without adding the ABP bits - then can come a separate ABP patch
>that adds the new hardware support - without touching any other code
>but adding its own small driver module.
>
>	Ingo
[[JPAN]] thanks for the detailed comments, I will fix the style problem in the
 next version. I can separate APB timer code into another patch. But I need
a little more clarification for the abstraction you want. The reason why I did
it this way was it is similar to the other arch_setup_xx, e.g. HPET. In
 io_apic.c 
So do you want to abstract all the arch_setup_xxx in the new abstraction layer?
