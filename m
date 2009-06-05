Return-Path: <linux-kernel-owner+w=401wt.eu-S1752965AbZFEKkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbZFEKkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 06:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbZFEKkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 06:40:05 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:59224 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbZFEKkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 06:40:04 -0400
Date: Fri, 5 Jun 2009 12:39:29 +0200
From: Harald Welte <HaraldWelte@viatech.com>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Message-ID: <20090605103929.GE4421@prithivi.gnumonks.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <alpine.LFD.2.01.0906041004000.4880@localhost.localdomain> <20090605071902.GD6411@prithivi.gnumonks.org> <200906050227.42295.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906050227.42295.lkml@morethan.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Fri, Jun 05, 2009 at 02:27:40AM -0500, Michael S. Zick wrote:

> > As a side note: The C7-M actually uses the same software interface as Intel CPU
> > for doing the power transitions (ACPI Performance States).   Only very early C7
> > models used the cpufreq/e_powersaver.c driver.
> 
> What is "very early C7 models" in terms of cpuid results?

I've inquired about that.

Looking at he code, the driver only seems to checking for a minimum CPUID
value, but doesn't contain a maximum.

Regards,
-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
