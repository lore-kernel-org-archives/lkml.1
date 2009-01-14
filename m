Return-Path: <linux-kernel-owner+w=401wt.eu-S1759913AbZANAMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913AbZANAMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 19:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbZANAM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 19:12:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753170AbZANAM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 19:12:27 -0500
Date: Tue, 13 Jan 2009 16:12:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: zbr@ioremap.net, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, dst@ioremap.net
Subject: Re: [0/7] Distributed storage for drivers/staging merge request
Message-Id: <20090113161221.b23510b4.akpm@linux-foundation.org>
In-Reply-To: <20090114000130.GA20811@kroah.com>
References: <1231887933-17843-1-git-send-email-zbr@ioremap.net>
	<20090113233932.GA18000@kroah.com>
	<20090113234734.GA32190@ioremap.net>
	<20090114000130.GA20811@kroah.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009 16:01:30 -0800
Greg KH <greg@kroah.com> wrote:

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
> 
> We take new drivers at almost any point in the release cycle, why should
> filesystems be any different?

Well...  the case for merging drivers is usually pretty simple - the
hardware exists, so we need the driver.

Whereas the "do we need this" case for new filesystems isn't this simple.
