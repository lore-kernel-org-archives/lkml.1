Return-Path: <linux-kernel-owner+w=401wt.eu-S1760807AbZANAQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760807AbZANAQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 19:16:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759243AbZANAPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 19:15:49 -0500
Received: from matrixpower.ru ([195.178.208.66]:58119 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758953AbZANAPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 19:15:48 -0500
Date: Wed, 14 Jan 2009 03:15:46 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, dst@ioremap.net
Subject: Re: [0/7] Distributed storage for drivers/staging merge request
Message-ID: <20090114001546.GC512@ioremap.net>
References: <1231887933-17843-1-git-send-email-zbr@ioremap.net> <20090113233932.GA18000@kroah.com> <20090113234734.GA32190@ioremap.net> <20090114000130.GA20811@kroah.com> <20090113161221.b23510b4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113161221.b23510b4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 04:12:21PM -0800, Andrew Morton (akpm@linux-foundation.org) wrote:
> > Hm, then why can't this whole thing just go into fs/dst/ right now?
> > It's self-contained, so there shouldn't be any special "must live in
> > staging" rule for filesystems before adding them.
> > 
> > We take new drivers at almost any point in the release cycle, why should
> > filesystems be any different?
> 
> Well...  the case for merging drivers is usually pretty simple - the
> hardware exists, so we need the driver.
> 
> Whereas the "do we need this" case for new filesystems isn't this simple.

More on this, it is a block device which does not work with hardware.
And yes, question is serious. And you may not believe, but it is not me
to answer this. I'm happy to provide any needed information.
In a nutshell, it is a network block device on really huge steroids.

-- 
	Evgeniy Polyakov
