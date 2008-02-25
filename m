Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbYBYPqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbYBYPqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 10:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756417AbYBYPqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 10:46:19 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:59121 "EHLO
	outbound6-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756332AbYBYPqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 10:46:17 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0JWSX4T-04-BBZ-01
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
Date: Mon, 25 Feb 2008 08:52:55 -0700
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "Andres Salomon" <dilinger@queued.net>
cc: "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       info-linux@geode.amd.com, mingo@redhat.com, hpa@zytor.com,
       akpm@linux-foundation.org
Subject: Re: x86: geode: MSR cleanup
Message-ID: <20080225155255.GE13031@cosmic.amd.com>
References: <20080224183300.037fa9c8@ephemeral>
MIME-Version: 1.0
In-Reply-To: <20080224183300.037fa9c8@ephemeral>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 25 Feb 2008 15:46:01.0794 (UTC)
 FILETIME=[85D96A20:01C877C5]
X-WSS-ID: 6BDC3D300QK12402385-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/02/08 18:33 -0500, Andres Salomon wrote:
> Note that I didn't bother cleaning up the gxfb and lxfb headers wrt MSRs;
> that's coming in another patch (which is still in progress).
> 
> 
> From 22b8ddf47f77f01a59afb937779f4c83e9862f9e Mon Sep 17 00:00:00 2001
> From: Andres Salomon <dilinger@debian.org>
> Date: Sun, 24 Feb 2008 13:14:57 -0500
> Subject: [PATCH] x86: geode: MSR cleanup
> 
> This cleans up a few MSR-using drivers in the following manner:
>   - Ensures MSRs are all defined in asm/geode.h, rather than in misc
>     places
>   - Makes the naming consistent; cs553[56] ones begin with MSR_,
>     GX-specific ones start with MSR_GX_, and LX-specific ones start
>     with MSR_LX_.  Also, make the names match the data sheet.
>   - Use MSR names rather than numbers in source code
>   - Document the fact that the LX's MSR_PADSEL has the wrong value
>     in the data sheet.  That's, uh, good to note.
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>

Acked-by: Jordan Crouse <jordan.crouse@amd.com>

Thanks for doing this - I'm always happy when stuff gets scratched off my
TODO list automatically.


