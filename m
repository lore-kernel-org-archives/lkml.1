Return-Path: <linux-kernel-owner+w=401wt.eu-S1756493AbXJ3PYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493AbXJ3PYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 11:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbXJ3PXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 11:23:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184AbXJ3PXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 11:23:51 -0400
Date: Tue, 30 Oct 2007 11:23:46 -0400
From: Rik van Riel <riel@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: Marcelo Tosatti <marcelo@kvack.org>, linux-kernel@vger.kernel.org,
       drepper@redhat.com
Subject: Re: OOM notifications
Message-ID: <20071030112346.4b48bfe5@cuia.boston.redhat.com>
In-Reply-To: <20071030145720.GB27039@atrey.karlin.mff.cuni.cz>
References: <20071018201531.GA5938@dmt>
	<20071030145720.GB27039@atrey.karlin.mff.cuni.cz>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 15:57:20 +0100
Jan Kara <jack@suse.cz> wrote:

>   Hello,
> 
> > AIX contains the SIGDANGER signal to notify applications to free up some
> > unused cached memory:
> > 
> > http://www.ussg.iu.edu/hypermail/linux/kernel/0007.0/0901.html
> > 
> > There have been a few discussions on implementing such an idea on Linux,
> > but nothing concrete has been achieved.
> > 
> > On the kernel side Rik suggested two notification points: "about to
> > swap" (for desktop scenarios) and "about to OOM" (for embedded-like
> > scenarios).
> > 
> > With that assumption in mind it would be necessary to either have two
> > special devices for notification, or somehow indicate both events
> > through the same file descriptor.
>   Actually, wouldn't a generic netlink interface be more elegant? Then
> we could connect it with DBUS and it would be much easier for
> applications (Desktop) to handle such events.
>   I agree that near-to-oom conditions are quite volatile and maybe we
> want a technically simple (and thus more reliable) mechanism for the
> notification but I anyway wanted to point to this possibility.

There's nothing wrong with being able to get this info via DBUS,
but we cannot expect every database and JVM out there (big targets
for the "reduce your memory footprint" thing on servers) to grow
a DBUS interface.

-- 
All Rights Reversed
