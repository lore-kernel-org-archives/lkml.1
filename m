Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbYE2USU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbYE2USU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 16:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbYE2USA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 16:18:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752766AbYE2UR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 16:17:56 -0400
Date: Thu, 29 May 2008 13:16:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
       eric.whitney@hp.com, linux-mm@kvack.org, npiggin@suse.de,
       riel@redhat.com
Subject: Re: [PATCH 00/25] Vm Pageout Scalability Improvements (V8) -
 continued
Message-Id: <20080529131624.60772eb6.akpm@linux-foundation.org>
In-Reply-To: <20080529195030.27159.66161.sendpatchset@lts-notebook>
References: <20080529195030.27159.66161.sendpatchset@lts-notebook>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 15:50:30 -0400
Lee Schermerhorn <lee.schermerhorn@hp.com> wrote:

> 
> The patches to follow are a continuation of the V8 "VM pageout scalability
> improvements" series that Rik van Riel posted to LKML on 23May08.  These
> patches apply atop Rik's series with the following overlap:
> 
> Patches 13 through 16 replace the corresponding patches in Rik's posting.
> 
> Patch 13, the noreclaim lru infrastructure, now includes Kosaki Motohiro's
> memcontrol enhancements to track nonreclaimable pages.
> 
> Patches 14 and 15 are largely unchanged, except for refresh.  Includes
> some minor statistics formatting cleanup.
> 
> Patch 16 includes a fix for an potential [unobserved] race condition during
> SHM_UNLOCK.
> 

<head spins a bit>

> 
> Additional patches in this series:
> 
> Patches 17 through 20 keep mlocked pages off the normal [in]active LRU
> lists using the noreclaim lru infrastructure.   These patches represent
> a fairly significant rework of an RFC patch originally posted by Nick Piggin.
> 
> Patches 21 and 22 are optional, but recommended, enhancements to the overall
> noreclaim series.  
> 
> Patches 23 and 24 are optional enhancements useful during debug and testing.
> 
> Patch 25 is a rather verbose document describing the noreclaim lru
> infrastructure and the use thereof to keep ramfs, SHM_LOCKED and mlocked
> pages off the normal LRU lists.
> 
> ---
> 
> The entire stack, including Rik's split lru patches, are holding up very
> well under stress loads.  E.g., ran for over 90+ hours over the weekend on
> both x86_64 [32GB, 8core] and ia64 [32GB, 16cpu] platforms without error
> over last weekend.  
> 
> I think these are ready for a spin in -mm atop Rik's patches.

I was >this< close to getting onto Rik's patches (honest) but a few
other people have been kicking the tyres and seem to have caused some
punctures so I'm expecting V9?
