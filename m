Return-Path: <linux-kernel-owner+w=401wt.eu-S1753776AbYC1Iuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbYC1Iuz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 04:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbYC1Iur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 04:50:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60815 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbYC1Iuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 04:50:46 -0400
Date: Fri, 28 Mar 2008 09:50:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86_64 boot -v2: Add linked listof struct
	setup_data to boot protocol
Message-ID: <20080328085015.GA21413@elte.hu>
References: <1206672578.13404.21.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206672578.13404.21.camel@caritas-dev.intel.com>
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


* Huang, Ying <ying.huang@intel.com> wrote:

> This patchset adds the linked list of struct setup_data to boot 
> protocol. This is needed by EDD information and some SGI machine with 
> E820 entry number > 128.
> 
> Now, only the x86_64 is supported. The i386 can be supported after 
> early reservation mechanism for x86 is available.
> 
> This patchset is based x86.git latest branch and has been tested on 
> Intel x86_64 machine.

thanks, applied. Note: as i mentioned, this code needs to be unified, 
and we can only merge this upstream into 2.6.26 once 32-bit support has 
been added too. The last thing we need is 64-bit only boot protocol 
extensions.

	Ingo
