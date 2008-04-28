Return-Path: <linux-kernel-owner+w=401wt.eu-S967278AbYD1XO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967278AbYD1XO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967575AbYD1XOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 19:14:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:54263 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966152AbYD1XOm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 19:14:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,718,1199692800"; 
   d="scan'208";a="322341830"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] x86: !x & y typo in mtrr code
Date: Mon, 28 Apr 2008 16:16:44 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEEF31AAF@orsmsx423.amr.corp.intel.com>
In-Reply-To: <1209268817.14173.43.camel@brick>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] x86: !x & y typo in mtrr code
Thread-Index: AcioG0AL6HCHNbVVS0GA77SBOvv1uwBamOyQ
References: <1209268817.14173.43.camel@brick>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Harvey Harrison" <harvey.harrison@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "LKML" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 28 Apr 2008 23:14:41.0297 (UTC) FILETIME=[A325D810:01C8A985]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org 
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of 
>Harvey Harrison
>Sent: Saturday, April 26, 2008 9:00 PM
>To: Ingo Molnar
>Cc: Thomas Gleixner; H. Peter Anvin; LKML
>Subject: [PATCH] x86: !x & y typo in mtrr code
>
>As written, this can never be true.
>

My bad. I introduced this ugly and nasty bug.

Harvey: Thanks for catching the bug and the patch.

Thanks,
Venki

>Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
>---
> arch/x86/kernel/cpu/mtrr/generic.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/arch/x86/kernel/cpu/mtrr/generic.c 
>b/arch/x86/kernel/cpu/mtrr/generic.c
>index 353efe4..5d241ce 100644
>--- a/arch/x86/kernel/cpu/mtrr/generic.c
>+++ b/arch/x86/kernel/cpu/mtrr/generic.c
>@@ -90,7 +90,7 @@ u8 mtrr_type_lookup(u64 start, u64 end)
> 	 * Look of multiple ranges matching this address and pick type
> 	 * as per MTRR precedence
> 	 */
>-	if (!mtrr_state.enabled & 2) {
>+	if (!(mtrr_state.enabled & 2)) {
> 		return mtrr_state.def_type;
> 	}
> 
>-- 
>1.5.5.1.270.g89765
>
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe 
>linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
