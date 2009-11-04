Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbZKDIDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbZKDIDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 03:03:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbZKDIDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 03:03:10 -0500
Received: from ozlabs.org ([203.10.76.45]:52067 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbZKDIDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 03:03:09 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 5/14] cpumask: use modern cpumask style in drivers/edac/amd64_edac.c
Date: Wed, 4 Nov 2009 18:33:07 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>,
       bluesmoke-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
References: <200911031456.35354.rusty@rustcorp.com.au> <20091103064347.GA8082@liondog.tnic>
In-Reply-To: <20091103064347.GA8082@liondog.tnic>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911041833.07866.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009 05:13:47 pm Borislav Petkov wrote:
> Hi,
> 
> On Tue, Nov 03, 2009 at 02:56:35PM +1030, Rusty Russell wrote:
> > cpumask_t -> struct cpumask, and don't put one on the stack.  (Note: this
> > is actually on the stack unless CONFIG_CPUMASK_OFFSTACK=y).
> > 
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> I've got a similar patch already queued up but it
> depends on the changes to rdmsr_on_cpus/wrmsr_on_cpus in
> b8a4754147d61f5359a765a3afd3eb03012aa052 which is in tip/x86/cpu and
> which does a bit more than your patch 4 so IMHO you could drop yours.
> 
> Concerning the edac change, yours is better and I could pick it up and
> add it to my patch queue if nobody else has a problem with that?

Less work for me sounds *excellent*.

Thanks!
Rusty.
