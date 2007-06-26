Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbXFZPjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbXFZPjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbXFZPjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:39:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54301 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757646AbXFZPjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:39:12 -0400
Date: Tue, 26 Jun 2007 17:39:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jesse Barnes <jesse.barnes@intel.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Message-ID: <20070626153911.GC5244@one.firstfloor.org>
References: <200706251434.43863.jesse.barnes@intel.com> <20070625233433.GA32306@one.firstfloor.org> <200706251636.53636.jesse.barnes@intel.com> <m1bqf3tu06.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bqf3tu06.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> For the K7 and K8 cores AMD systems are exactly like Intel systems
> with respect to MTRRs (although AMD systems also have additional registers)
> For the K9 core (i.e. AMD socket F or the K8 with DDR2 support) there

It's called K8RevE, not K9

> is an additional mechanism that makes everything above 4G write-back
> cacheable without using any MTRRs.

... but not BIOS use this mechanism (often there are BIOS switches
for several MTRR models or it is just the wrong one hardcoded), so Linux 
should detect the broken cases.

-Andi
