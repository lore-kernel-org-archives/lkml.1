Return-Path: <linux-kernel-owner+w=401wt.eu-S1752787AbYG1XcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbYG1XcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 19:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbYG1Xb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 19:31:57 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:42444 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751146AbYG1Xb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 19:31:56 -0400
Date: Tue, 29 Jul 2008 08:31:19 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: magnus.damm@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: bad CONFIG variable references from Makefiles
Message-ID: <20080728233119.GC28055@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"Robert P. J. Day" <rpjday@crashcourse.ca>, magnus.damm@gmail.com,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.10.0807281607400.28285@localhost.localdomain> <20080728205439.GA27744@linux-sh.org> <alpine.LFD.1.10.0807281923310.31937@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807281923310.31937@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 07:24:47PM -0400, Robert P. J. Day wrote:
> On Tue, 29 Jul 2008, Paul Mundt wrote:
> 
> > On Mon, Jul 28, 2008 at 04:09:28PM -0400, Robert P. J. Day wrote:
> > >
> > >   a complete list of all references to non-existent CONFIG variables
> > > exclusively from Makefiles in the tree.  since the list is so short,
> > > i'm not bothering to break it up by subsystem or arch.  enjoy.
> > >
> > >
> > > ===== FB_SH7343VOU =====
> > > ./drivers/video/Makefile:obj-$(CONFIG_FB_SH7343VOU)	  += sh7343_voufb.o
> >
> > Seems to have crept in from a working local tree. It's obviously
> > bogus and can simply be killed off.
> 
> ok, i can slap together a patch unless someone else gets to it first.
> 
Already in my tree, forgot to mention :-)
