Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbYHDNnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbYHDNnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbYHDNnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:43:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:46783 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbYHDNnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:43:05 -0400
Date: Mon, 4 Aug 2008 06:42:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Dave Airlie <airlied@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [patch 0/2] reduce agpgart memory allocation time
Message-ID: <20080804064258.29366cd1@infradead.org>
In-Reply-To: <1217834079.9799.1.camel@sli10-desk.sh.intel.com>
References: <1217832677.21811.7.camel@sli10-desk.sh.intel.com>
	<21d7e9970808032353m40fcea6dtbf1b7bc1c5cf06d9@mail.gmail.com>
	<1217834079.9799.1.camel@sli10-desk.sh.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Aug 2008 15:14:39 +0800
Shaohua Li <shaohua.li@intel.com> wrote:

> > 
> > I proposed an alternative interface but I failed to get it merged
> > and ran out of time
> > http://www.ussg.iu.edu/hypermail/linux/kernel/0804.3/1112.html
> > 
> > I was trying to get the cpa interface to allow arrays of pages to be
> > passed in, I was then going to change AGP like
> > http://git.kernel.org/?p=linux/kernel/git/airlied/agp-2.6.git;a=shortlog;h=agp-pageattr2
> This is good too.
> 
> > I really should fix those patches up at some point, feel free to
> > base a system on those if someone objects to the method with the
> > call site doing the flush.
> Ok, if people object the method, I'll refresh your patches.
> 

I much rather have the vector method; with that we can also fold in the
PAT checks into a vectored approach (which saves another 0.3 second)
