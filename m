Return-Path: <linux-kernel-owner+w=401wt.eu-S932943AbXDUGsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943AbXDUGsd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 02:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932997AbXDUGsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 02:48:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932943AbXDUGsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 02:48:31 -0400
Date: Sat, 21 Apr 2007 02:48:16 -0400
From: Dave Jones <davej@redhat.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: [RFC PATCH 1/3] x86: use defined names for all CPU feature flags
Message-ID: <20070421064816.GA4293@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Chuck Ebbert <cebbert@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <ak@suse.de>
References: <4629438C.4070209@redhat.com> <46294444.1050608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46294444.1050608@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 06:52:52PM -0400, Chuck Ebbert wrote:

 > --- 2.6.21-rc7-d390.orig/arch/x86_64/kernel/setup.c
 > +++ 2.6.21-rc7-d390/arch/x86_64/kernel/setup.c
 > @@ -576,7 +576,7 @@ static void __cpuinit init_amd(struct cp
 >  
 >  	/* Bit 31 in normal CPUID used for nonstandard 3DNow ID;
 >  	   3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway */
 > -	clear_bit(0*32+31, &c->x86_capability);
 > +	clear_bit(X86_FEATURE_PBE, &c->x86_capability);

The comment suggests this should be X86_FEATURE_3DNOW
Same for the other instances.

	Dave

-- 
http://www.codemonkey.org.uk
