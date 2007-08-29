Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbXH2EtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbXH2EtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 00:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbXH2EtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 00:49:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60540 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423AbXH2EtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 00:49:11 -0400
Date: Tue, 28 Aug 2007 21:49:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible
 fashion.
Message-Id: <20070828214900.5d4b47ad.akpm@linux-foundation.org>
In-Reply-To: <20070828230459.GA15937@infradead.org>
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com>
	<20070828230459.GA15937@infradead.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Aug 2007 00:04:59 +0100 Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Aug 28, 2007 at 04:40:15PM -0600, Eric W. Biederman wrote:
> > +When:	September 2010
> > +Option: CONFIG_SYSCTL_SYSCALL
> > +Why:	The same information is available in a more convenient from
> > +	/proc/sys, and none of the sysctl variables appear to be
> > +	important performance wise.
> > +
> > +	Binary sysctls are a long standing source of subtle kernel
> > +	bugs and security issues.
> > +
> > +	When I looked several months ago all I could find after
> > +	searching several distributions were 5 user space programs and
> > +	glibc (which falls back to /proc/sys) using this syscall.
> 
> Umm, no way we're ever going to remove a syscall like this.  Please
> stop this deprecration crap.  Just make sure no ones adds more binary
> sysctls.

I think it's worth a try.  It might take two, three or five years, who
knows?  If it turns out to be impractical then we we can just change our
minds later, no big loss.  It's just too early to say right now.


