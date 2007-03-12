Return-Path: <linux-kernel-owner+w=401wt.eu-S965580AbXCLN35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965580AbXCLN35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965582AbXCLN34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:29:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:46864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965580AbXCLN3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:29:55 -0400
Date: Mon, 12 Mar 2007 14:29:43 +0100 (CET)
From: Michael Matz <matz@suse.de>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@argo.co.il>, discuss@x86-64.org, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [discuss] [PATCH 4/4 TRY#3] optimize and simplify get_cycles_sync()
In-Reply-To: <20070312130245.GE8922@amd.com>
Message-ID: <Pine.LNX.4.64.0703121427381.25448@wotan.suse.de>
References: <20070309150825.GA13481@amd.com> <20070309151511.GE13481@amd.com>
 <45F1A2FB.7040206@argo.co.il> <20070312130245.GE8922@amd.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

On Mon, 12 Mar 2007, Joerg Roedel wrote:

> > >+#define RDTSCP ".byte 0x0f, 0x01, 0xf9"
> > >+	alternative_io_two("cpuid\nrdtsc",
> > >+			   "rdtsc", X86_FEATURE_SYNC_RDTSC,
> > >+			   ".byte 0x0f, 0x01, 0xf9", X86_FEATURE_RDTSCP,
> > >  
> > 
> > why not use the RDTSCP macro here?
> 
> Does this macro exist?

Look carefully at your patch again, or at least the four quoted lines 
above.  You've added it yourself, in exactly the form you'd need in the 
alternative_io_two() call :-)

> I couldn't found it in the current git tree. And the rdtscp macros in 
> msr.h use the plain opcode too.


Ciao,
Michael.
