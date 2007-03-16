Return-Path: <linux-kernel-owner+w=401wt.eu-S965713AbXCPRPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965713AbXCPRPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 13:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965739AbXCPRPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 13:15:01 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:49699 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965713AbXCPRPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 13:15:00 -0400
Date: Fri, 16 Mar 2007 10:12:50 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Adrian Bunk <bunk@stusta.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 20/26] Xen-paravirt_ops: Core Xen implementation
Message-ID: <20070316171250.GM10574@sequoia.sous-sol.org>
References: <20070301232443.195603797@goop.org> <20070301232528.812011702@goop.org> <20070316091411.GF23174@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070316091411.GF23174@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> >  ENTRY(swapper_pg_dir)
> > +	.align PAGE_SIZE_asm
> >  	.fill 1024,4,0
> 
> does the native kernel lose memory here?

Not in my builds.
