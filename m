Return-Path: <linux-kernel-owner+w=401wt.eu-S932713AbXCEN7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713AbXCEN7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932791AbXCEN7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:59:20 -0500
Received: from ns.suse.de ([195.135.220.2]:51660 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932713AbXCEN7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:59:19 -0500
Date: Mon, 5 Mar 2007 15:58:47 +0100
From: Andi Kleen <ak@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, Avi Kivity <avi@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch] paravirt: VDSO page is essential
Message-ID: <20070305145847.GH22829@bingen.suse.de>
References: <20070305120631.GA14105@elte.hu> <45EC0EB7.7080300@qumranet.com> <20070305142820.GD22829@bingen.suse.de> <20070305134854.GA31542@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305134854.GA31542@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 02:48:54PM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > The problem is not the syscall instruction, but some problem with the 
> > way the vDSO mapping is set up with CONFIG_PARAVIRT that broke older 
> > glibc.
> 
> the problem is that CONFIG_PARAVIRT silently turns off 
> CONFIG_COMPAT_VDSO, which of course breaks 'old' glibc. This too is a 
> must-have fix for v2.6.21.

We seem to have different definitions of must-have.

I think we would need to have a paravirt ops callback to decide this
first. But it doesn't look critical to me anyways.

-Andi
