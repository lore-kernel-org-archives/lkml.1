Return-Path: <linux-kernel-owner+w=401wt.eu-S1764822AbYBMTod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764822AbYBMTod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 14:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759827AbYBMToT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 14:44:19 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38515 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759303AbYBMToR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 14:44:17 -0500
Date: Wed, 13 Feb 2008 11:43:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Travis <travis@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, ak@suse.de, clameter@sgi.com,
       steiner@sgi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       len.brown@intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/4] acpi: change cpufreq tables to per_cpu variables
Message-Id: <20080213114317.0698a2b2.akpm@linux-foundation.org>
In-Reply-To: <47B33278.3060408@sgi.com>
References: <20080208233738.108449000@polaris-admin.engr.sgi.com>
	<20080208233738.427702000@polaris-admin.engr.sgi.com>
	<20080212153356.d2be3248.akpm@linux-foundation.org>
	<47B33278.3060408@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 10:10:00 -0800
Mike Travis <travis@sgi.com> wrote:

> Andrew Morton wrote:
> > On Fri, 08 Feb 2008 15:37:40 -0800
> > Mike Travis <travis@sgi.com> wrote:
> > 
> >> Change cpufreq tables from arrays to per_cpu variables in
> >> drivers/acpi/processor_thermal.c
> >>
> >> Based on linux-2.6.git + x86.git
> > 
> > I fixed a bunch of rejects in "[PATCH 1/4] cpufreq: change cpu freq tables
> > to per_cpu variables" and it compiles OK.  But this one was beyond my
> > should-i-repair-it threshold, sorry.
> 
> Should I rebase all the pending patches on 2.6.25-rc1 or 2.6.24-mm1
> (or some other combination)?
> 

That depends on whether you have other things queued in one of the git
trees.  If not, against current mainline (which is later than 2.6.25-rc1!)
would suit.

