Return-Path: <linux-kernel-owner+w=401wt.eu-S1755685AbXHSPiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbXHSPiA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 11:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbXHSPhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 11:37:50 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1329 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbXHSPht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 11:37:49 -0400
Subject: Re: tracking MAINTAINERS versus tracking SUBSYSTEMS
From: Joe Perches <joe@perches.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0708190818280.7224@localhost.localdomain>
References: <Pine.LNX.4.64.0708181311490.10387@localhost.localdomain>
	 <1187483578.4200.51.camel@localhost>
	 <Pine.LNX.4.64.0708190818280.7224@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 19 Aug 2007 08:37:45 -0700
Message-Id: <1187537866.4200.97.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-19 at 08:22 -0400, Robert P. J. Day wrote:
> On Sat, 18 Aug 2007, Joe Perches wrote:
> > On Sat, 2007-08-18 at 13:35 -0400, Robert P. J. Day wrote:
> > >   $ show_subsystem drivers/bluetooth/bpa10x.c
> > >   BLUETOOTH
> > "what's a subsystem"? I'm not sure there is an appropriate
> > definition. If there is an appropriate definition, why should anyone
> > care what subsystem a particular file is in?
> i'm confused -- i thought that was sort of the whole purpose of this
> exercise, to match parts of the kernel source tree against the
> maintainer for those parts, and to do that via the defined
> "subsystem" which is currently used in MAINTAINERS.

What I did was for patch submission.

That script should probably be named "get_patch_cc_list".
It does now by default use git to find and include the
most frequent signatories.

I think that descriptions of subsystems are not
particularly useful.  The file hierarchy should
effectively do that.  I think a tool to inform a
"list of interested parties" when a file is touched
is useful though.

If there is to be a subsystem definition, I think it
needs to be hierarchical with things like specific
net drivers not a subsystem, but an element of the
subsystem net:drivers (or drivers:net or both).

If these elements are bundled together into a single
"subsystem" descriptor file you will run into the "hot"
file problem that Linus described.

cheers,  Joe

