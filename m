Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbYDIPG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbYDIPG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 11:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbYDIPGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 11:06:51 -0400
Received: from relay2.sgi.com ([192.48.171.30]:40939 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751928AbYDIPGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 11:06:50 -0400
Date: Wed, 9 Apr 2008 10:06:49 -0500 (CDT)
From: Alan Mayer <ajm@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Mayer <ajm@sgi.com>, torvalds@linux-foundation.org,
       linux-kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Change FIRST_SYSTEM_VECTOR to a variable.
In-Reply-To: <20080409145945.GB17100@elte.hu>
Message-ID: <Pine.SGI.3.96.1080409100423.8706317F-100000@fergus.americas.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2008, Ingo Molnar wrote:

> 
> * Alan Mayer <ajm@sgi.com> wrote:
> 
> > Subject: [PATCH] x86_64: Change FIRST_SYSTEM_VECTOR to a variable.
> > 
> > From: Alan Mayer <ajm@sgi.com>
> > 
> > The SGI UV system needs several more system vectors than a vanilla 
> > x86_64 system.  Rather than burden the other archs with extra system 
> > vectors that they don't use, change FIRST_SYSTEM_VECTOR to a variable, 
> > so that it can be dynamic.
> 
> nice - but please split this up into two patches: first one that changes 
> the generic code to use a variable limit - this patch will (should) be a 
> functional NOP.
> 
> then a second patch adds those two new UV vectors.
> 
> Also, could you please also change the 32-bit side as well so that we at 
> least keep the two implementations roughly in sync?
> 
> 	Ingo
> 

Sure, I can do that.

		--ajm


Now he lives in the islands
And fishes the pylons
And drinks his Green Label each day.
--
Alan J. Mayer
SGI
ajm@sgi.com
WORK: 651-683-3131
HOME: 651-407-0134
--

