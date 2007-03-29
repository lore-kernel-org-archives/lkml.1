Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbXC2JxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbXC2JxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 05:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbXC2JxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 05:53:13 -0400
Received: from ns2.suse.de ([195.135.220.15]:49447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbXC2JxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 05:53:12 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] x86: tighten kernel image page access rights
Date: Thu, 29 Mar 2007 11:53:07 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, patches@x86-64.org
References: <4607F177.76E4.0078.0@novell.com> <200703282107.11511.ak@suse.de> <460B843C.76E4.0078.0@novell.com>
In-Reply-To: <460B843C.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703291153.07557.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 March 2007 09:17, Jan Beulich wrote:
> >>> Andi Kleen <ak@suse.de> 28.03.07 21:07 >>>
> >
> >> +#ifdef CONFIG_HOTPLUG_CPU
> >> +	/* It must still be possible to apply SMP alternatives. */
> >> +	if (num_possible_cpus() <= 1)
> >
> >It would be better to temporarily change the pages where the alternatives
> >are applied while that is done and keep it otherwise ro
> 
> I had considered that, but not done so due to the larger resulting patch.
> Are you okay with doing this as a follow-up step?

Yes. I tried to apply the original patch, but gots lots of rejects.
Can you please resubmit that one against the latest firstfloor tree? 

-Andi
