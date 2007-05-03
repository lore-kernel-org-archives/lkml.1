Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbXECTFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbXECTFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 15:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbXECTFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 15:05:24 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37203 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755353AbXECTFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 15:05:23 -0400
Date: Thu, 3 May 2007 21:05:22 +0200
From: Adrian Bunk <bunk@stusta.de>
To: David Rientjes <rientjes@google.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] compiler: define __attribute_unused__
Message-ID: <20070503190522.GM3531@stusta.de>
References: <Pine.LNX.4.64.0705012254160.21685@chino.kir.corp.google.com> <1178087393.28659.238.camel@localhost.localdomain> <Pine.LNX.4.64.0705012336430.22339@chino.kir.corp.google.com> <1178089444.28659.246.camel@localhost.localdomain> <Pine.LNX.4.64.0705020020420.22717@chino.kir.corp.google.com> <20070502145550.GE3531@stusta.de> <20070502150546.GF3531@stusta.de> <Pine.LNX.4.64.0705021014070.3033@chino.kir.corp.google.com> <20070503175125.GL3531@stusta.de> <Pine.LNX.4.64.0705031154310.2312@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705031154310.2312@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 11:56:34AM -0700, David Rientjes wrote:
> On Thu, 3 May 2007, Adrian Bunk wrote:
> 
> > > That's only addressing part of the issue.  What about automatic or static 
> > > external variables that are declared but may go unreferenced depending on 
> > 
> > This is only about static code. For non-static code it would be
> > impossible for gcc to issue warnings.
> 
> static external variables are certainly still static code and gcc issues 
> the proper warnings if I do:
> 
> 	static struct bootnode nodes[MAX_NUMNODES];
> 
> and I never reference nodes.

No disagreement.

But you said:
  What about automatic or static external variables that are declared but ...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

