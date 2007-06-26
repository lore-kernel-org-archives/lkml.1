Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbXFZRi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbXFZRi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 13:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757997AbXFZRiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 13:38:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57201 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757911AbXFZRiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 13:38:08 -0400
Date: Tue, 26 Jun 2007 19:38:06 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jesse Barnes <jesse.barnes@intel.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Message-ID: <20070626173806.GE5244@one.firstfloor.org>
References: <200706251434.43863.jesse.barnes@intel.com> <20070625233433.GA32306@one.firstfloor.org> <200706251636.53636.jesse.barnes@intel.com> <m1bqf3tu06.fsf@ebiederm.dsl.xmission.com> <20070626153911.GC5244@one.firstfloor.org> <m1wsxqsnse.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wsxqsnse.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 10:06:41AM -0600, Eric W. Biederman wrote:
> Andi Kleen <andi@firstfloor.org> writes:
> 
> >> For the K7 and K8 cores AMD systems are exactly like Intel systems
> >> with respect to MTRRs (although AMD systems also have additional registers)
> >> For the K9 core (i.e. AMD socket F or the K8 with DDR2 support) there
> >
> > It's called K8RevE, not K9
> 
> revF not revE.  I think AMD was code-naming that K9 before the socket F
> part was released.

I didn't think so.

> 
> revE was the last DDR rev of the K8 core.

RevE had a new memory remapping scheme (memory hoisting) at least, which
I think you refered to earlier.  There might have been more changes in F.

-Andi
