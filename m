Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbXKGCul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbXKGCul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 21:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbXKGCuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 21:50:32 -0500
Received: from fep03.mfe.bur.connect.com.au ([203.63.86.23]:61460 "EHLO
	fep03.mfe.bur.connect.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441AbXKGCub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 21:50:31 -0500
Message-ID: <4731361D.9030504@ii.net>
Date: Wed, 07 Nov 2007 11:50:53 +0800
From: Cliffe <cliffe@ii.net>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Peter Dolding <oiaohm@gmail.com>
CC: Crispin Cowan <crispin@crispincowan.com>, Simon Arlott <simon@fire.lp0.eu>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: Defense in depth: LSM *modules*, not a static interface
References: <10965.80.126.27.205.1193684677.squirrel@webmail.xs4all.nl>	 <4726377A.4080807@crispincowan.com>	 <e7d8f83e0710292213h4cf9cddw6e373d60fbab41f9@mail.gmail.com>	 <4726D9D9.2000909@ii.net> <29685.simon.1193747418@5ec7c279.invalid>	 <472FE383.70103@crispincowan.com> <47301739.3010604@ii.net> <e7d8f83e0711061559l26ff4d27gc97f809af6d8b979@mail.gmail.com>
In-Reply-To: <e7d8f83e0711061559l26ff4d27gc97f809af6d8b979@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As good an idea POSIX capabilities might be, not all security problems 
can be solved with a bitmap of on/off permissions.

Peter Dolding wrote:
> "AppArmor profile denies all network traffic to a specific
> application"  Ok why should AppArmor be required to do this.  Would it
> not be better as as part of Capabilities that is always there and is
> application controllable.  It would be a security advantage if data
> processing threads that don't do network access inside a application
> don't have it.  Basically this feature could be done in mirror.  Allow
> Network access Capabilities flag.  Not set application cannot access
> network at all.  All LSM's would be able to use that to cut of network
> access to applications.  As a standard feature of kernel if a new
> network stack or some other alteration is done LSM hooks would not
> need altering.  Lot of LSM hooks would disappear.  Need for LSM to
> monitor and run different code to kernel in a lot of places would also
> disappear.
>
> With Capabilities expand it to point that applications cannot do
> anything without permissions.  Both models are do able.  Restrictive
> can be done in a Permissive model effectively if the starting point of
> the Permissive is that you cannot do anything without permissions
> being granted.  Big different is that the Permissive Model is the
> kernel default.  Some LSM are design in conflict with the main model
> of the OS.  You really only want one model from speed point of view

Ok but what happens to the principle of least privilege?

What if we want AppArmor to confine that application to use a particular 
set of ports?

Do you propose having a capability for each port? how about protocols?

So unless my understanding of capabilities is fundamentally flawed 
(which it may be - I have not spent time reviewing recent changes) 
obviously Linux capabilities does not provide a solution to every problem.

Regards,

Cliffe.

--

Z. Cliffe Schreuders
BSc Comp Sci (Hons) & Int Comp
PhD Candidate, Casual Tutor
School of IT
Murdoch University
