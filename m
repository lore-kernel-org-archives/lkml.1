Return-Path: <linux-kernel-owner+w=401wt.eu-S1760328AbXKHKPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760328AbXKHKPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 05:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756655AbXKHKPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 05:15:34 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:42278 "EHLO
	mail45-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbXKHKPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 05:15:33 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Date: Thu, 8 Nov 2007 11:14:57 +0100
From: "Robert Richter" <robert.richter@amd.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/6] x86: apicdef unification: some constants made
 unsigned
Message-ID: <20071108101457.GF20836@erda.amd.com>
References: <20071106183645.951275000@amd.com>
 <20071106183646.064906000@amd.com> <473222E5.7020808@goop.org>
MIME-Version: 1.0
In-Reply-To: <473222E5.7020808@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 08 Nov 2007 10:14:57.0928 (UTC)
 FILETIME=[37094080:01C821F0]
X-WSS-ID: 6B2C3E2A24S1815381-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.11.07 12:41:09, Jeremy Fitzhardinge wrote:
> > -#define			GET_APIC_VERSION(x)	((x)&0xFF)
> > -#define			GET_APIC_MAXLVT(x)	(((x)>>16)&0xFF)
> > -#define			APIC_INTEGRATED(x)	((x)&0xF0)
> > +#define			GET_APIC_VERSION(x)	((x)&0xFFu)
> > +#define			GET_APIC_MAXLVT(x)	(((x)>>16)&0xFFu)
> > +#define			APIC_INTEGRATED(x)	((x)&0xF0u)
> 
> Can these ever be used in .S files?  Might be better to use the _AC stuff.

I did not want to make functional changes, just do a simple
merge. However there are already updated files in the x86/cleanup
tree, so these patches are obsolete.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com


