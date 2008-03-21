Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbYCUIyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbYCUIyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 04:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbYCUIy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 04:54:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48116 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbYCUIy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 04:54:26 -0400
Date: Fri, 21 Mar 2008 09:54:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>, Andi Kleen <ak@suse.de>,
       shai@scalex86.org
Subject: Re: [patch 0/4] x86: vSMP updates
Message-ID: <20080321085401.GB20420@elte.hu>
References: <20080320073740.GA9414@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320073740.GA9414@localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> Hi Ingo, Andrew,
> Here are a few updates to the vSMP architecture bits in the x86 tree.
> This is a set of 4 patches which do the following:
> 
> 1. Fix is_vsmp_box() to actually detect if the system is a vSMPowered box
> 2. Fix build issue when CONFIG_PCI is enabled, but CONFIG_PARAVIRT is not
> 3. Set paravirt ops only if the platform has capability to recognize
>    paravirtualized irq operations
> 4. Update apic_is_clustered_box() to indicate unsynched TSCs on multiboard
>    vSMPowered systems
> 
> The patches have been tested against 2.6.25-rc5-mm1 on vSMPowered and 
> non vSMPowered x86 boxes.

thanks Ravikiran, applied them (with one fix).

	Ingo
