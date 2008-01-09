Return-Path: <linux-kernel-owner+w=401wt.eu-S1755583AbYAITbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbYAITbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 14:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYAITbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 14:31:45 -0500
Received: from relay1.sgi.com ([192.48.171.29]:54351 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752120AbYAITbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 14:31:44 -0500
Date: Wed, 9 Jan 2008 11:31:43 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Dave Hansen <haveblue@us.ibm.com>
cc: travis@sgi.com, Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       Andi Kleen <ak@suse.de>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, tglx@linutronix.de,
       mingo@redhat.com
Subject: Re: [PATCH 10/10] x86: Unify percpu.h
In-Reply-To: <1199906905.9834.101.camel@localhost>
Message-ID: <Pine.LNX.4.64.0801091130420.11317@schroedinger.engr.sgi.com>
References: <20080108211023.923047000@sgi.com>  <20080108211025.293924000@sgi.com>
 <1199906905.9834.101.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008, Dave Hansen wrote:

> On Tue, 2008-01-08 at 13:10 -0800, travis@sgi.com wrote:
> > Form a single percpu.h from percpu_32.h and percpu_64.h. Both are now pretty
> > small so this is simply adding them together. 
> 
> I guess I just don't really see the point of moving the code around like
> this.  Before, it would have been easier to tell at a glance before
> whether you were looking at 32 or 64-bit code because of which file you
> are in.  But, now, you need to look for #ifdef context.  I'm not sure
> that's a win.
> 
> This only saves 5 net lines of code, and those are probably from:
> 
> -#ifndef __ARCH_I386_PERCPU__
> -#define __ARCH_I386_PERCPU__
> 
> right?
> 
> The rest of the set looks brilliant, though.  

Well this is only the first patchset. The next one will unify this even 
more (and make percpu functions work consistent between the two arches) 
but it requires changes to the way the %gs register is used in 
x86_64. So we only do the simplest thing here to have one file to patch 
against later.


