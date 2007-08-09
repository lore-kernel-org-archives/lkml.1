Return-Path: <linux-kernel-owner+w=401wt.eu-S932812AbXHIJqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbXHIJqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 05:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbXHIJqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 05:46:36 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:59050 "EHLO
	outbound9-dub-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756629AbXHIJqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 05:46:35 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
From: "Joachim Deguara" <joachim.deguara@amd.com>
Organization: AMD
To: "Frank Hale" <frankhale@gmail.com>
Subject: Re: ACPI on Averatec 2370
Date: Thu, 9 Aug 2007 11:45:44 +0200
User-Agent: KMail/1.9.7
cc: "Andi Kleen" <andi@firstfloor.org>, "Cal Peake" <cp@absolutedigital.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       "Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel ACPI Mailing List" <linux-acpi@vger.kernel.org>,
       len.brown@intel.com, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0707301048460.5693@lancer.cnet.absolutedigital.net>
 <200708081642.00581.joachim.deguara@amd.com>
 <5ebbd9b50708081652h55c85f9avab4500391c6b7ee0@mail.gmail.com>
In-Reply-To: <5ebbd9b50708081652h55c85f9avab4500391c6b7ee0@mail.gmail.com>
MIME-Version: 1.0
Message-ID: <200708091145.46500.joachim.deguara@amd.com>
X-OriginalArrivalTime: 09 Aug 2007 09:45:49.0470 (UTC)
 FILETIME=[11487BE0:01C7DA6A]
X-WSS-ID: 6AA43DDA7CS4744758-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 August 2007 01:52:37 Frank Hale wrote:
> I have the latest BIOS update for my laptop which is buggy I suppose.
> There has been only one update this year if my memory serves me
> correctly. Is there any hope to fix this or am I at the mercy of the
> hardware vendor which apparenlty doesn't look like they will release
> another patch this year. 

You can fix this with the kernel parameter nolapic_timer as Cal reported 
earlier that working right, or try Andi's patch to automagically mark the 
lapic as bad.  This should work fine with ACPI.
The BIOS is at fault but Andi's patch just works around the BIOS' 
incompleteness and has been successful for two other people.

-Joachim




