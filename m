Return-Path: <linux-kernel-owner+w=401wt.eu-S1758378AbYCYPvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378AbYCYPvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 11:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757620AbYCYPu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 11:50:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43552 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757546AbYCYPu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:50:56 -0400
Date: Tue, 25 Mar 2008 16:50:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>, shai@scalex86.org
Subject: Re: [patch 4/4] x86: apic_is_clustered_box to indicate unsynched
	TSC's on multiboard vSMP systems
Message-ID: <20080325155032.GC27174@elte.hu>
References: <20080320073740.GA9414@localdomain> <20080320074508.GE9414@localdomain> <86802c440803200053m1b0928a9q6567d8c619fa7a2f@mail.gmail.com> <20080320190240.GB6085@localdomain> <20080321091542.GE20420@elte.hu> <20080321185225.GA23139@localdomain> <20080321185821.GE6571@elte.hu> <20080322185948.GD23139@localdomain> <20080322200251.GB5508@elte.hu> <20080324214836.GA6045@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080324214836.GA6045@localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0312]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> Sure.  Here's the modified patch.
> 
> vSMP detection: Access pci config space early in boot to detect if the 
> system is a vSMPowered box, and cache the result in a flag, so that 
> is_vsmp_box() retrieves the value of the flag always.

thanks, applied.

	Ingo
