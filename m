Return-Path: <linux-kernel-owner+w=401wt.eu-S1758801AbYBORqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801AbYBORqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 12:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbYBORqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 12:46:06 -0500
Received: from anchor-post-32.mail.demon.net ([194.217.242.90]:4644 "EHLO
	anchor-post-32.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755007AbYBORqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 12:46:05 -0500
Subject: Re: kernel-doc : possible fix for non-fatal perl errors when
	parsing some function pointers
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080215092154.4a8cbba7.rdunlap@xenotime.net>
References: <1203095592.2929.54.camel@castor.localdomain>
	 <20080215092154.4a8cbba7.rdunlap@xenotime.net>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 17:42:24 +0000
Message-Id: <1203097344.2929.63.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-15 at 09:21 -0800, Randy Dunlap wrote:
> On Fri, 15 Feb 2008 17:13:12 +0000 Richard Kennedy wrote:
> 
> > When running "make htmldocs" I'm seeing some non-fatal perl errors
> > caused by trying to parse the callback function definitions in
> > blk-core.c.
> > 
> >
> 
> Hi Richard,
> Thanks for the patch.  I was planning to look into this problem
> this weekend.
> 
> I think that changing scripts/kernel-doc to accept the current
> kernel source tree usage is the right thing to do, even if the
> block/blk code is a bit different.  I'll test it a bit and then
> push it.
> 
> I appreciate the patch.
> 
No problem. 

I have given the patch some testing, and the output xml is the same
except for the blk_end_request_callback entry.

But I wonder if it should change to this :-

> -         $type =~ s/([^\(]+\(\*)$param/$1/;
> +         $type =~ s/([^\(]+\(\*?)\s*$param/$1/;

just in case there is some stray whitespace in there.

Richard

> ---
> ~Randy

