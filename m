Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbYDJOiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbYDJOiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756014AbYDJOiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:38:05 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:18414 "EHLO
	outbound1-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755882AbYDJOiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:38:04 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0JZ45WH-02-52F-01
Date: Thu, 10 Apr 2008 08:42:00 -0600
From: Jordan Crouse <jordan.crouse@amd.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       info-linux@geode.amd.com
Subject: Re: x86: GEODE: add Virtual Systems Architecture detection
Message-ID: <20080410144200.GF13663@cosmic.amd.com>
References: <20080409223328.5774d6cf@ephemeral> <20080410091057.45cbb938@core> <20080410094024.5111e108@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410094024.5111e108@ephemeral>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 10 Apr 2008 14:36:04.0268 (UTC) FILETIME=[348486C0:01C89B18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/08 09:40 -0400, Andres Salomon wrote:
> On Thu, 10 Apr 2008 09:10:57 +0100
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > On Wed, 9 Apr 2008 22:33:28 -0400
> > Andres Salomon <dilinger@queued.net> wrote:
> > 
> > > 
> > > This is generic VSA detection.  It's used by OLPC to determine whether or
> > > not the BIOS contains VSA, but since other BIOSes are coming out that don't
> > > use the VSA (ie, tinybios), it might end up being useful for others.
> > 
> > NAK - but minor
> > 
> > This is a check for *VSA2* which is not the same as VSA1 (Cyrix one) and
> > for older systems that actually matters as you may have VSA1 or VSA2 and
> > they are detected differently.
> >
> 
> Excellent point.  Can we extend this to check for a VSA1-specific
> string, or does VSA1 not have a similar signature?

I don't think we need to worry about it.  99.99% of Geode systems run
with VSA happily transparent in the background, and thus would have no
good reason to check for it.  Certainly, there are no processors with VSA1
that would care to check.

But Alan does have a good point - we should name it vsa2 for 
strict correctness.

Jordan
-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.

