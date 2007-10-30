Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbXJ3O5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbXJ3O5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 10:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbXJ3O5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 10:57:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:46630 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbXJ3O5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 10:57:21 -0400
Date: Tue, 30 Oct 2007 15:57:20 +0100
From: Jan Kara <jack@suse.cz>
To: Marcelo Tosatti <marcelo@kvack.org>
Cc: linux-kernel@vger.kernel.org, drepper@redhat.com, riel@redhat.com
Subject: Re: OOM notifications
Message-ID: <20071030145720.GB27039@atrey.karlin.mff.cuni.cz>
References: <20071018201531.GA5938@dmt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018201531.GA5938@dmt>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

> AIX contains the SIGDANGER signal to notify applications to free up some
> unused cached memory:
> 
> http://www.ussg.iu.edu/hypermail/linux/kernel/0007.0/0901.html
> 
> There have been a few discussions on implementing such an idea on Linux,
> but nothing concrete has been achieved.
> 
> On the kernel side Rik suggested two notification points: "about to
> swap" (for desktop scenarios) and "about to OOM" (for embedded-like
> scenarios).
> 
> With that assumption in mind it would be necessary to either have two
> special devices for notification, or somehow indicate both events
> through the same file descriptor.
  Actually, wouldn't a generic netlink interface be more elegant? Then
we could connect it with DBUS and it would be much easier for
applications (Desktop) to handle such events.
  I agree that near-to-oom conditions are quite volatile and maybe we
want a technically simple (and thus more reliable) mechanism for the
notification but I anyway wanted to point to this possibility.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
