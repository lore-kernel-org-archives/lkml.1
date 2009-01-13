Return-Path: <linux-kernel-owner+w=401wt.eu-S1759552AbZAMXrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552AbZAMXrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:47:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbZAMXrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:47:36 -0500
Received: from matrixpower.ru ([195.178.208.66]:43378 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755550AbZAMXrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:47:35 -0500
Date: Wed, 14 Jan 2009 02:47:34 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, dst@ioremap.net
Subject: Re: [0/7] Distributed storage for drivers/staging merge request
Message-ID: <20090113234734.GA32190@ioremap.net>
References: <1231887933-17843-1-git-send-email-zbr@ioremap.net> <20090113233932.GA18000@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113233932.GA18000@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 03:39:32PM -0800, Greg KH (greg@kroah.com) wrote:
> On Wed, Jan 14, 2009 at 02:05:26AM +0300, Evgeniy Polyakov wrote:
> > Patches were split on per-file basis, so tree in the middle of the series will not
> > compile, which should not be a problem, since kconfig/makefile changes are introduced
> > in the latest patch.
> 
> Looks good to me, but do we need the "export these symbols" patch to get
> this to work properly as well?

No, exports are needed for POHMELFS which I'm waiting a reply from
Andrew or Linus.

> Also, can you send me a patch with a TODO file in the
> drivers/staging/dst/ directory, detailing what needs to be done on it to
> move it over to the main portion of the kernel?

Nothing :)

Really. I implemented all the suggestions I got from the previous
reviews (including spaces and documentations, which btw were the only
ones :) way too long ago and did not get any other complaints. Actually
the tree I sent to you does not contain documentation update I have in
the own tree (pointed during review), so this can be added as todo entry :)
My fault I found that too late.

-- 
	Evgeniy Polyakov
