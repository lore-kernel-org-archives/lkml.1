Return-Path: <linux-kernel-owner+w=401wt.eu-S1764719AbYEAVJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764719AbYEAVJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759593AbYEAVJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:09:05 -0400
Received: from vigor.karmaclothing.net ([217.169.26.28]:52252 "EHLO
	dl5rb.ham-radio-op.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756835AbYEAVJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:09:04 -0400
Date: Thu, 1 May 2008 22:05:36 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, johnstul@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: shift helper
Message-ID: <20080501210536.GA6135@linux-mips.org>
References: <20080501173123.444094226@mvista.com> <20080501123245.d71245ad.akpm@linux-foundation.org> <1209671305.12461.262.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209671305.12461.262.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 12:48:25PM -0700, Daniel Walker wrote:

> > If we expect this to have more than one callsite then it would be best to
> > uninline it.
> > 
> > Unless we always expect it to be called from __init code, in which case
> > it's best to inline it ;)
> 
> I expect it would always get called from __init flagged functions. The
> clocksource can't get registed/used with out the shift and mult values. 
> 
> If we did uninline this one, we would have to do the other helpers too.
> I imagine the use case is the same for all of them ..

I could imagine this being called for hotpluggable CPUs or nodes, so rather
__cpuinit than __init.

  Ralf
