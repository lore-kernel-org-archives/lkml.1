Return-Path: <linux-kernel-owner+w=401wt.eu-S1760120AbXK1ADU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760120AbXK1ADU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 19:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbXK1ADJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 19:03:09 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40169 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753686AbXK1ADI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 19:03:08 -0500
Date: Tue, 27 Nov 2007 16:03:07 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>
Subject: Re: [patch 05/14] percpu: Use a Kconfig variable to configure arch
 specific percpu setup
In-Reply-To: <20071127154055.35e07833.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0711271600510.7293@schroedinger.engr.sgi.com>
References: <20071127001407.859743255@sgi.com> <20071127001430.313046247@sgi.com>
 <20071127154055.35e07833.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007, Randy Dunlap wrote:

> > +config ARCH_SETS_UP_PER_CPU_AREA
> > +	bool
> > +	default y
> 
> 	def_bool y
>   is the preferred form for those 2-liners above...
> 
> 
> > +
> >  config ARCH_NO_VIRT_TO_BUS
> >  	def_bool y
> >  

Ok. Changed.

x86 should use

config ARCH_SETS_UP_PER_CPU_AREA
        def_bool X86_64

?

