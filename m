Return-Path: <linux-kernel-owner+w=401wt.eu-S1760646AbZANAIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760646AbZANAIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 19:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757156AbZANAIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 19:08:41 -0500
Received: from corega.com.ru ([195.178.208.66]:59679 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278AbZANAIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 19:08:40 -0500
Date: Wed, 14 Jan 2009 03:08:39 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Greg KH <greg@kroah.com>
Cc: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, dst@ioremap.net
Subject: Re: [0/7] Distributed storage for drivers/staging merge request
Message-ID: <20090114000839.GA512@ioremap.net>
References: <1231887933-17843-1-git-send-email-zbr@ioremap.net> <20090113233932.GA18000@kroah.com> <20090113234734.GA32190@ioremap.net> <20090114000130.GA20811@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114000130.GA20811@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 04:01:30PM -0800, Greg KH (greg@kroah.com) wrote:
> > Really. I implemented all the suggestions I got from the previous
> > reviews (including spaces and documentations, which btw were the only
> > ones :) way too long ago and did not get any other complaints. Actually
> > the tree I sent to you does not contain documentation update I have in
> > the own tree (pointed during review), so this can be added as todo entry :)
> > My fault I found that too late.
> 
> Hm, then why can't this whole thing just go into fs/dst/ right now?
> It's self-contained, so there shouldn't be any special "must live in
> staging" rule for filesystems before adding them.

Its a block device not a filesystem, so it is more like a driver.
All original patches placed it into the drivers/block/dst without touch
any external files except makefile and kconfig.

> We take new drivers at almost any point in the release cycle, why should
> filesystems be any different?

I suppose this is a rethorical question, since there is no answer :)

> Linus, Andrew, any objections?

Hi there!

-- 
	Evgeniy Polyakov
