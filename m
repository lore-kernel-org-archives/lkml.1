Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbZG1WSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbZG1WSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 18:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755810AbZG1WSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 18:18:40 -0400
Received: from sg2ehsobe004.messaging.microsoft.com ([207.46.51.78]:26917 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755798AbZG1WSj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 18:18:39 -0400
X-SpamScore: -23
X-BigFish: VPS-23(zz542N1432R9371Pzz1202hzzz32i6bh203h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KNIJAQ-02-1KN-02
X-M-MSG: 
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 0/26] oprofile: Performance counter multiplexing
Date: Tue, 28 Jul 2009 17:18:26 -0500
Message-ID: <0F3CDC76A0A8FB48A8C88865301C4F12973BC0@SAUSEXMB2.amd.com>
In-Reply-To: <87ljm8hcjx.fsf@basil.nowhere.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 0/26] oprofile: Performance counter multiplexing
Thread-Index: AcoPs/YtXgCtIHIeQjGZNKlFXWyGRAAHLcvQ
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com> <87ljm8hcjx.fsf@basil.nowhere.org>
From: "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To: "Andi Kleen" <andi@firstfloor.org>,
       "Richter, Robert" <robert.richter@amd.com>
CC: "LKML" <linux-kernel@vger.kernel.org>,
       "oprofile-list" <oprofile-list@lists.sourceforge.net>
X-OriginalArrivalTime: 28 Jul 2009 22:18:27.0725 (UTC) FILETIME=[54B59BD0:01CA0FD1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The user-space support is currently in AMD CodeAnalyst utility.  I am
working on the more generic user-space support (non-AMD specific) and
will send the patches to OProfile for review.

Suravee

-----Original Message-----
From: Andi Kleen [mailto:andi@firstfloor.org] 
Sent: Tuesday, July 28, 2009 1:45 PM
To: Richter, Robert
Cc: LKML; oprofile-list
Subject: Re: [PATCH 0/26] oprofile: Performance counter multiplexing

Robert Richter <robert.richter@amd.com> writes:
>  	  If unsure, say N.
>  
> +config OPROFILE_EVENT_MULTIPLEX
> +	bool "OProfile multiplexing support (EXPERIMENTAL)"
> +	default n
> +	depends on OPROFILE && X86
> +	help
> +	  The number of hardware counters is limited. The multiplexing
> +	  feature enables OProfile to gather more events than counters
> +	  are provided by the hardware. This is realized by switching
> +	  between events at an user specified time interval.
> +

I would suggest to drop that CONFIG and have the code unconditional.
It's not a lot code and should be always available.

Will do more detailed review later and will look at Intel P6 support.

Where's the userland support for this?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

------------------------------------------------------------------------
------
Let Crystal Reports handle the reporting - Free Crystal Reports 2008
30-Day 
trial. Simplify your report design, integration and deployment - and
focus on 
what you do best, core application coding. Discover what's new with 
Crystal Reports now.  http://p.sf.net/sfu/bobj-july
_______________________________________________
oprofile-list mailing list
oprofile-list@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/oprofile-list


