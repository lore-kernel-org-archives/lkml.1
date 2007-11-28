Return-Path: <linux-kernel-owner+w=401wt.eu-S1762113AbXK1Rc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762113AbXK1Rc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 12:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762035AbXK1RcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 12:32:17 -0500
Received: from mx1.suse.de ([195.135.220.2]:42056 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762034AbXK1RcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 12:32:16 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
Date: Wed, 28 Nov 2007 18:31:27 +0100
User-Agent: KMail/1.9.6
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Roland Dreier <rdreier@cisco.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, sam@ravnborg.org
References: <20071122343.446909000@suse.de> <20071127230645.GB31491@one.firstfloor.org> <20071128164817.GK3406@stusta.de>
In-Reply-To: <20071128164817.GK3406@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711281831.27379.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 November 2007 17:48:17 Adrian Bunk wrote:
> On Wed, Nov 28, 2007 at 12:06:45AM +0100, Andi Kleen wrote:
> > On Tue, Nov 27, 2007 at 03:00:22PM -0800, Stephen Hemminger wrote:
> >...
> > > of a modular ipv6 is flawed. 
> > 
> > Modules that cannot be unloaded are still useful. Standard case: Distributions
> > like to offer an option to not use ipv6 because that is popular workaround
> > for the common "DNS server eats AAAA queries and causes delays" issue.
> > Forcing the user to rebuild the kernel for this wouldn't be practical.
> > If ipv6 wasn't modular that would be hard to do.
> 
> It should be trivial doing it similar to the selinux=0 boot option.

They safe also a few hundred KB of memory this way.
I know it is not en vogue anymore to care about memory bloat, but
I personally like that.

-Andi 

