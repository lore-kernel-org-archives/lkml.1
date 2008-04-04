Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbYDDW3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbYDDW3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 18:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbYDDW3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 18:29:23 -0400
Received: from ozlabs.org ([203.10.76.45]:56272 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbYDDW3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 18:29:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Marc Pignat <marc.pignat@hevs.ch>
Subject: Re: module parameters versus kernel command line
Date: Sat, 5 Apr 2008 08:29:00 +1000
User-Agent: KMail/1.9.9
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Tom Horsley <tom.horsley@ccur.com>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>
References: <20080403090053.56f243df@tomh> <200804040909.28983.rusty@rustcorp.com.au> <200804041345.38482.marc.pignat@hevs.ch>
In-Reply-To: <200804041345.38482.marc.pignat@hevs.ch>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804050829.00418.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 April 2008 21:45:37 Marc Pignat wrote:
> On Friday 04 April 2008, Rusty Russell wrote:
> ...
>
> > The second is that users might be surprised when they take
> > the 'usbcore.blinkenlights' line out of their modprobe config file and it
> > still applies.  Most users use everything-is-a-module distributions.
>
> Why don't do it in user space (let insmod/modprobe parse /proc/cmdline)?
> 1. Users won't be surprised after looking at the new man pages:)
> 2. it will work with older kernel
>
> The warning problem is more complicated to fix.

I like this idea, and also have module tools ship with 
a 'check-kernel-cmdline' tool which handles the warnings for unusable cmdline 
params.  Distributions can run this in their init scripts, and we can remove 
the warning from the kernel.

The best bit about this idea: it's now Jon's problem :)

Cheers,
Rusty.
