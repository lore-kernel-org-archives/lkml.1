Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbXGDSJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbXGDSJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 14:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755485AbXGDSJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 14:09:10 -0400
Received: from gw.goop.org ([64.81.55.164]:45477 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438AbXGDSJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 14:09:10 -0400
Message-ID: <468BE240.60909@goop.org>
Date: Wed, 04 Jul 2007 11:09:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: Re: [PATCH] x86: make SMP locks handling interact properly with	CONFIG_DEBUG_RODATA
 (2nd try)
References: <468B5B54.76E4.0078.0@novell.com> <468BBFB3.9080303@goop.org> <20070704175142.GA3795@redhat.com>
In-Reply-To: <20070704175142.GA3795@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Wed, Jul 04, 2007 at 08:41:39AM -0700, Jeremy Fitzhardinge wrote:
>  
>  > I'd already posted a patch to remove smp alternatives.  I thought it had 
>  > been merged already, but I guess it's in Andi's queue.
>
> What was the rationale behind that?  Given many distros have now
> moved to shipping just an SMP kernel, this seems like a step backwards?
>   

No, there's two mechanisms.  There's the clobber the lock prefix thing, 
which is unaffected.  And there's smp_alternatives, which was a more 
ambitious mechanism to completely replace instructions in the SMP vs 
non-SMP cases, which is completely unused and therefore removed.

    J
