Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbYCKUkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbYCKUkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 16:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbYCKUj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 16:39:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43448 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859AbYCKUj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 16:39:57 -0400
Date: Tue, 11 Mar 2008 13:39:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: serge@hallyn.com
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: 2.6.25-rc5-mm1
Message-Id: <20080311133920.68dc410b.akpm@linux-foundation.org>
In-Reply-To: <20080311202300.GA8957@vino.hallyn.com>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
	<20080311202300.GA8957@vino.hallyn.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008 15:23:00 -0500 serge@hallyn.com wrote:

> Quoting Andrew Morton (akpm@linux-foundation.org):
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/
> > 
> > - Added the kgdb tree as git-kgdb-light (Jason Wessel, Ingo Molnar)
> > 
> > - Added a random-security-stuff-apart-from-selinux tree as
> >   git-security-testing (James Morris)
> > 
> > - suspend-to-disk is still busted on my x86_64 t61p (git-x86, iirc)
> 
> Compiles and boots perfectly on s390 here.

whee.

Things are going much much more smoothly now than they were in 2.6.24-rcX
and 2.6.23-rcX.  Tree integration problems are negligible and build errors
are far fewer and runtime problems seem to be less too.   Fingers crossed.

I guess this is due to a combinaton of

a) linux-next

b) intensive whining and

c) extra care which maintainers are taking (due to a) and b))


I suspect that fewer people are testing linux-next and -mm nowadays.  We
should encourage them to do so, although given the general
trainwreckishness of current mainline, this isn't really where our effort
should be expended.
