Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbXJXTyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbXJXTyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 15:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbXJXTyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 15:54:16 -0400
Received: from waste.org ([66.93.16.53]:36277 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177AbXJXTyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 15:54:16 -0400
Date: Wed, 24 Oct 2007 14:53:48 -0500
From: Matt Mackall <mpm@selenic.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jan Beulich <jbeulich@novell.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_XEN dependencies
Message-ID: <20071024195348.GM17536@waste.org>
References: <471DE2F8.76E4.0078.0@novell.com> <471E38D6.5050202@xensource.com> <471F1EEE.76E4.0078.0@novell.com> <471F965B.6090200@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471F965B.6090200@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 12:00:43PM -0700, Jeremy Fitzhardinge wrote:
> Jan Beulich wrote:
> > The specific goal is to be able to enable the XEN option in our native kernel,
> > which gets configured with M586. So we could live with XEN depending on
> > X86_CMPXCHG, but would definitely need the dependency on X86_TSC
> > dropped. Nevertheless I'd favor even X86_CMPXCHG dropped unless that
> > causes unresolvable (or difficult to resolve) problems.
> 
> Seems reasonable.  Do you have a patch?

You might want a runtime check for these features as a future Xen
hypervisor might eliminate these requirements.

Ok, not really likely, but still possible.

-- 
Mathematics is the supreme nostalgia of our time.
