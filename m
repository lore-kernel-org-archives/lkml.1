Return-Path: <linux-kernel-owner+w=401wt.eu-S1753703AbYKTFES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbYKTFES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 00:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbYKTFEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 00:04:00 -0500
Received: from colo.lackof.org ([198.49.126.79]:58024 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbYKTFEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 00:04:00 -0500
Date: Wed, 19 Nov 2008 22:03:47 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       ralf@linux-mips.org, Ingo Molnar <mingo@redhat.com>,
       grundler@parisc-linux.org, jeremy@xensource.com
Subject: Re: [PATCH 1/1] cpumask: make irq_set_affinity() take a const
	struct cpumask
Message-ID: <20081120050347.GA6252@colo.lackof.org>
References: <200811200110.44281.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811200110.44281.rusty@rustcorp.com.au>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 01:10:43AM +1030, Rusty Russell wrote:
> (Ingo, this is for you directly, not linux-next).
> 
> Not much point with gentle transition here: the struct irq_chip's
> setaffinity method signature needs to change.
> 
> Fortunately, not widely used code, but hits a few architectures.
...
> Cc: grundler@parisc-linux.org
...
>  drivers/parisc/iosapic.c        |    7 +--
...

Reviewed-by: Grant Grundler <grundler@parisc-linux.org>

thanks,
grant
