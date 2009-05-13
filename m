Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbZEMI6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbZEMI6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 04:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbZEMI6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 04:58:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:35711 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbZEMI6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 04:58:08 -0400
Subject: Re: [PATCH 3/10 -tip] x86: Add cpufeatures for Advanced Power
 Management
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       Robert Richter <robert.richter@amd.com>, Dave Jones <davej@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
In-Reply-To: <alpine.LFD.2.00.0905122219420.3561@localhost.localdomain>
References: <1242142530.2547.11.camel@ht.satnam>
	 <1242142623.2547.13.camel@ht.satnam>  <1242142692.2547.15.camel@ht.satnam>
	 <1242142753.2547.16.camel@ht.satnam> <1242155190.2492.73.camel@ht.satnam>
	 <alpine.LFD.2.00.0905122219420.3561@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 13 May 2009 14:27:18 +0530
Message-Id: <1242205038.3346.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-12 at 23:04 +0200, Thomas Gleixner wrote:
> Jaswinder,
> 
> On Wed, 13 May 2009, Jaswinder Singh Rajput wrote:
> > +	/* Advanced Power Management (Function 8000_0007h), edx */
> > +	if (c->extended_cpuid_level >= 0x80000007) {
> > +		c->x86_capability[9] = cpuid_edx(0x80000007);
> 
> In the reply to [Patch 5/10] Ingo wrote:
> >> Also, open-coding x86_capability[9] like that is quite unclean. Were 
> >> we ever to reorder those bits internally, this could would break.
> 
> Do you really believe that open-coding x86_capability[9] in .../common.c
> is better than the open-coding in ../powernow-k8.c ?
> 
> Again, open-coding is wrong and error prone. Ingo explicitely asked for a
> helper function. All you did is moving the open-coded hard wired array
> reference to a different place.
> 
> Please start to listen to the review comments as long as people are
> willing to look at your patches. Seriously, the noise/useful ratio of
> your patches is annoying and adds an unjustified burden to the
> maintainers of that code.
> 

Ok, trashed complete cpu_debug and cpufeature patches, I hope it will
makes maintainers happy and save their precious time.

Anyway thanks for being so helpful and making my task easier :-)

--
JSR

