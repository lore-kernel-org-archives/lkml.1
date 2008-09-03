Return-Path: <linux-kernel-owner+w=401wt.eu-S1753146AbYICP7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbYICP7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 11:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbYICP7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 11:59:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996AbYICP7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 11:59:13 -0400
Date: Wed, 3 Sep 2008 08:58:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/2] lib: add generic helper to print sizes rounded to
 the correct SI range
Message-Id: <20080903085852.ee31fee8.akpm@linux-foundation.org>
In-Reply-To: <1220452354.3254.11.camel@localhost.localdomain>
References: <48B9546B.4010004@simon.arlott.org.uk>
	<1220117091.3615.3.camel@localhost.localdomain>
	<20080830174516.GD1239@parisc-linux.org>
	<48B9B552.8060406@simon.arlott.org.uk>
	<48B9B588.7060709@simon.arlott.org.uk>
	<1220147947.3615.18.camel@localhost.localdomain>
	<20080831025412.GJ1239@parisc-linux.org>
	<1220195310.4021.4.camel@localhost.localdomain>
	<1220195634.4021.9.camel@localhost.localdomain>
	<20080902203914.4ddf3735.akpm@linux-foundation.org>
	<1220452354.3254.11.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Sep 2008 09:32:34 -0500 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> > > +	snprintf(buf, len, "%lld%s%s", size, tmp, units_str[units][i]);
> > 
> > Can't print a u64 - we don't know what type it has.  It must be cast to
> > something, usually unsigned long long.
> 
> I thought there was a patch from Matthew to move u64 to unsigned long
> long on all architectures, thus obviating this annoying conversion ...
> is that still wandering upstream, or has it been dropped?

It broke, and it needs vast numbers of conversions in the arch code.
