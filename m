Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbYEXISl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbYEXISl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 04:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYEXIS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 04:18:28 -0400
Received: from sous-sol.org ([216.99.217.87]:37454 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbYEXIS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 04:18:26 -0400
Date: Sat, 24 May 2008 01:17:54 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Dave Jones <davej@codemonkey.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, bojan@rexursive.com,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>
Subject: Re: capget() overflows buffers.
Message-ID: <20080524081754.GW30402@sequoia.sous-sol.org>
References: <20080522140402.GB2071@codemonkey.org.uk> <20080522175744.GE4018@sequoia.sous-sol.org> <20080522205341.GA30402@sequoia.sous-sol.org> <4835F929.7010200@kernel.org> <20080522233757.GD30402@sequoia.sous-sol.org> <48366D9A.70806@kernel.org> <20080523182602.GO30402@sequoia.sous-sol.org> <48375B10.10003@kernel.org> <20080524010923.GT30402@sequoia.sous-sol.org> <48379C48.5020802@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48379C48.5020802@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew G. Morgan (morgan@kernel.org) wrote:
> Chris Wright wrote:
> | Hmm, it would be kind of nice to have a formalized way get the size,
> | perhaps it would help with KaiGai's request for caps printed out.
> | Something that tells us either the number of u32s, or the max bit
> | supported?
>
> Serge has already provided one  with the call,
>
> ~   sys_prctl(PR_CAPBSET_READ, x);
>
> returns -EINVAL if (x > max-supported-capability).
>
> (Ref: 3b7391de67da515c91f48aa371de77cb6cc5c07e)

Yeah, that's a little roundabout..

> Just to be clear, you are not referring to a warning that the
> application is stuck in a 32-bit capability world, because we already
> have one of those: warn_legacy_capability_use(). You are referring to a
> warning that might indicate a problem with code like that given in your
> example - in which case I'll respond to that part of the thread...

Yes, like the one in the patch I sent that added a
warn_broken_capability_use().

thanks,
-chris
