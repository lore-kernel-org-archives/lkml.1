Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934595Ab0BYX6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 18:58:30 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:65467 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934566Ab0BYX62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 18:58:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Huw6r3jFCUv5nGVQD8wVly3RgOhNqLTM84A5w4xEqLqPGfeOjGU4CTHz+VfIZPbK9S
         1yn8hfv6NHgRNHVSox6iIDmOL1+IAA1VAkRagLxmXGguMpyxM4XyA1/mluZ9E4MSXz+w
         6TWbXAZzbFCr1xb6I1dNz/Q8qGYnuIKTTZBZM=
Date: Fri, 26 Feb 2010 00:58:24 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/8] x86,kgdb: Implement early hardware breakpoint
	debugging
Message-ID: <20100225235822.GE5592@nowhere>
References: <1267132926-23685-1-git-send-email-jason.wessel@windriver.com> <1267132926-23685-4-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267132926-23685-4-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 03:22:01PM -0600, Jason Wessel wrote:
> It is not possible to use the hw_breakpoint.c API prior to mm_init(),
> but it is possible to use hardware breakpoints with the kernel
> debugger.
> 
> Prior to smp_init() it is possible to simply write to the dr registers
> of the boot cpu directly.  This can be used up until the
> kgdb_arch_late() is invoked, at which point the standard hw_breakpoint.c
> API will get used.
> 
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> ---


That looks good to me at a quick glance.

