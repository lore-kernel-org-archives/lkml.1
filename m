Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbXFZQH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbXFZQH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 12:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbXFZQHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 12:07:16 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57251 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788AbXFZQHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 12:07:14 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <andi@firstfloor.org>
Cc: Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Justin Piszcz <jpiszcz@lucidpixels.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
References: <200706251434.43863.jesse.barnes@intel.com>
	<20070625233433.GA32306@one.firstfloor.org>
	<200706251636.53636.jesse.barnes@intel.com>
	<m1bqf3tu06.fsf@ebiederm.dsl.xmission.com>
	<20070626153911.GC5244@one.firstfloor.org>
Date: Tue, 26 Jun 2007 10:06:41 -0600
In-Reply-To: <20070626153911.GC5244@one.firstfloor.org> (Andi Kleen's message
	of "Tue, 26 Jun 2007 17:39:11 +0200")
Message-ID: <m1wsxqsnse.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

>> For the K7 and K8 cores AMD systems are exactly like Intel systems
>> with respect to MTRRs (although AMD systems also have additional registers)
>> For the K9 core (i.e. AMD socket F or the K8 with DDR2 support) there
>
> It's called K8RevE, not K9

revF not revE.  I think AMD was code-naming that K9 before the socket F
part was released.

revE was the last DDR rev of the K8 core.

>> is an additional mechanism that makes everything above 4G write-back
>> cacheable without using any MTRRs.
>
> ... but not BIOS use this mechanism (often there are BIOS switches
> for several MTRR models or it is just the wrong one hardcoded), so Linux 
> should detect the broken cases.

Yes. They are and I have seen at least two motherboards that fit this
description.  I almost freaked out looking at a system with 16G and
only 4G setup to be cached.

The painful bit is I have also seen such a system with not all of the
lower 4G cached.  Which caused some interesting booting issues.

Eric
