Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbZKLVGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbZKLVGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 16:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754361AbZKLVGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 16:06:06 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:11904 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbZKLVGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 16:06:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=msuPsw2Sbr6f2eUMdU5xynOGotK/kWxNKMfOd5XD4z4rQY8FFbN0geFI9UF5YZlA7c
         NGt8jkBW7N0gaYfULrqcS4KXhbDOCcJ0hR1KiBpurBhmwdJ1wElWGRUayPlWv++z+QtG
         vN4/yGeL1nDOQNVzceufy5r+aGm2yTT7a0Pq0=
Date: Fri, 13 Nov 2009 00:06:06 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Yinghai Lu <yinghai@kernel.org>, x86team <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86,io-apic: Do not map IO-APIC direct registers
	twice
Message-ID: <20091112210606.GD5728@lenovo>
References: <20091112204852.GB5728@lenovo> <20091112205459.GC5728@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112205459.GC5728@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 11:54:59PM +0300, Cyrill Gorcunov wrote:
> On Thu, Nov 12, 2009 at 11:48:52PM +0300, Cyrill Gorcunov wrote:
> > Please review, I didn't manage to test (emulate actually since I don't
> > have such a hardware) it yet (going to do so this weekend).
> > 
> > Meanwhile I would like to heard comments, complains and etc...
> > Perhaps I miss something obvious so don't hesitate to poke me.
> > 
> > 	-- Cyrill
> > ---
> > x86,io-apic: Do not map IO-APIC direct registers twice
> > 
> ...
> I know that I've occasionally removed
> 
> 	apic_printk(APIC_VERBOSE, "mapped IOAPIC
> 		to %08lx (%08lx)\n",
> 
> already fixed in v2, just do not post updated version here.
> 
> 	-- Cyrill

Forgot to mention that I know this double for() over nr_ioapics
is slowlest approach but firstly I need to be sure that this
idea works in general/simple way before speedup it.

	-- Cyrill
