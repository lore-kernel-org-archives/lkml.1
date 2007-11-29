Return-Path: <linux-kernel-owner+w=401wt.eu-S934304AbXK2X3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934304AbXK2X3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 18:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932839AbXK2X3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 18:29:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:32459 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932923AbXK2X3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 18:29:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,231,1194249600"; 
   d="scan'208";a="218138122"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Subject: RE: constant_tsc and TSC unstable
Date: Thu, 29 Nov 2007 15:29:49 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE2FAA12@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20071129171142.56c7890a@tux.DEF.witbe.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: constant_tsc and TSC unstable
Thread-Index: AcgypERhj0w4Ihm5Qp+GkObyB/q0OgAOuiIA
References: <20071129171142.56c7890a@tux.DEF.witbe.net>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: =?iso-2022-jp?B?UGF1bCBSb2xsYW5kICgbJEIlXSE8JWshJiVtJWklcxsoQik=?= 
	<rol@witbe.net>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
X-OriginalArrivalTime: 29 Nov 2007 23:29:33.0176 (UTC) FILETIME=[B25F8780:01C832DF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org 
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Paul 
>Rolland (???・???)
>Sent: Thursday, November 29, 2007 8:12 AM
>To: Linux Kernel
>Cc: rol@witbe.net
>Subject: constant_tsc and TSC unstable
>
>Hello,
>
>I've a machine with a Core2Duo CPU. /proc/cpuinfo reports the flag
>constant_tsc, but at boot time, I have the log :
>
>...
>Total of 2 processors activated (6919.15 BogoMIPS).
>ENABLING IO-APIC IRQs
>..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
>checking TSC synchronization [CPU#0 -> CPU#1]:
>Measured 3978592228 cycles TSC warp between CPUs, turning off 
>TSC clock.
>Marking TSC unstable due to: check_tsc_sync_source failed.
>Brought up 2 CPUs
>...
>
>This machine is running 2.6.23.1-21.fc7. I know I should 
>report to Fedora,
>but I was wondering if this is a bug or a feature ;)
>

TSCs on Core 2 Duo are supposed to be in sync unless CPU supports deep idle states like C2, C3. Can you send the full /proc/cpuinfo and full dmesg.

Thanks,
Venki 
