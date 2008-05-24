Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbYEXILQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbYEXILQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 04:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYEXILA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 04:11:00 -0400
Received: from sous-sol.org ([216.99.217.87]:57351 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbYEXIK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 04:10:58 -0400
Date: Sat, 24 May 2008 01:07:34 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Dave Jones <davej@codemonkey.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, bojan@rexursive.com,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>
Subject: Re: capget() overflows buffers.
Message-ID: <20080524080734.GV30402@sequoia.sous-sol.org>
References: <20080522140402.GB2071@codemonkey.org.uk> <20080522175744.GE4018@sequoia.sous-sol.org> <20080522205341.GA30402@sequoia.sous-sol.org> <4835F929.7010200@kernel.org> <20080522233757.GD30402@sequoia.sous-sol.org> <48366D9A.70806@kernel.org> <20080523155718.GI30402@sequoia.sous-sol.org> <4837B4F5.4000100@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4837B4F5.4000100@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew G. Morgan (morgan@kernel.org) wrote:
> Your concern is for the situation when the garbage happens to correspond
> to an apparently meaningful setting for the upper capability bits? The
> problem being that this privileged application is more privileged than
> intended? I agree that this is not ideal.

Yep, exactly.

> In practice, however, this is only a real problem if named (or a
> similarly structured program) has a security related bug in it. No?

It's dropped privileges to help mitigate any security related bug it
may contain.  It's conceivable (albeit remote[1]) that fork/exec plus
inheritable could leak privs w/out a security related bug.

> Is this your concern, or have I missed something?

That's it.

thanks,
-chris

[1] Get lucky combo in the garbage bits and have not shed uid 0.
Much less likely.
