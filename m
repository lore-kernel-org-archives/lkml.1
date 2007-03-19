Return-Path: <linux-kernel-owner+w=401wt.eu-S932716AbXCSSWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716AbXCSSWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 14:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932642AbXCSSWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 14:22:35 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:42851 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932716AbXCSSWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 14:22:34 -0400
Date: Mon, 19 Mar 2007 11:15:51 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Adrian Bunk <bunk@stusta.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 20/26] Xen-paravirt_ops: Core Xen implementation
Message-ID: <20070319181551.GA10574@sequoia.sous-sol.org>
References: <20070301232443.195603797@goop.org> <20070301232528.812011702@goop.org> <20070316091411.GF23174@elte.hu> <20070316171250.GM10574@sequoia.sous-sol.org> <m1aby9xg5s.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1aby9xg5s.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric W. Biederman (ebiederm@xmission.com) wrote:
> Chris Wright <chrisw@sous-sol.org> writes:
> 
> > * Ingo Molnar (mingo@elte.hu) wrote:
> >> >  ENTRY(swapper_pg_dir)
> >> > +	.align PAGE_SIZE_asm
> >> >  	.fill 1024,4,0
> >> 
> >> does the native kernel lose memory here?
> >
> > Not in my builds.
> 
> Shouldn't the align be before the label.  Otherwise padding
> would be inserted between the label and the data.

Yes, I think you're right.  Thanks
-chris
