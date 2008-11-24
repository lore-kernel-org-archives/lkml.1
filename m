Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbYKXEYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbYKXEYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 23:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbYKXEYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 23:24:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48463 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbYKXEYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 23:24:10 -0500
Date: Sun, 23 Nov 2008 21:22:31 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       zaitcev@redhat.com
Subject: Re: linux-next: rr tree build failure
Message-Id: <20081123212231.63cc02d6.zaitcev@redhat.com>
In-Reply-To: <20081122064132.GA6196@suse.de>
References: <20081121141913.90d05091.sfr@canb.auug.org.au>
	<200811212128.52317.rusty@rustcorp.com.au>
	<20081121183403.GC16353@suse.de>
	<200811221301.07058.rusty@rustcorp.com.au>
	<20081122064132.GA6196@suse.de>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008 22:41:32 -0800, Greg KH <gregkh@suse.de> wrote:

> > > > This reverts to the 2005 (pre- aafbf24a) behaviour where "nousb" was
> > > > not a module parameter, just a kernel command line parameter.  That's
> > > > more sensible anyway.

By the way, I floated the idea to remove "nousb" altogether on fedora-devel.
Alan Cox replied that he has an actual box that requires it,
because of a bug in SMM BIOS... Imagine my surprise. I think we're
stuck with "nousb" for a little while still.

-- Pete
