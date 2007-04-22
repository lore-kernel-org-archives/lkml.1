Return-Path: <linux-kernel-owner+w=401wt.eu-S1030800AbXDVMz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030800AbXDVMz3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 08:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030814AbXDVMz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 08:55:29 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34159 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030800AbXDVMz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 08:55:28 -0400
Date: Sun, 22 Apr 2007 13:58:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tilman Schmidt <tilman@imap.cc>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       kkeil@suse.de, i4ldeveloper@listserv.isdn4linux.de,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Remove "obsolete" label from ISDN4Linux (v3)
Message-ID: <20070422135835.037e323c@the-village.bc.nu>
In-Reply-To: <462B54A0.9000203@imap.cc>
References: <20070115172912.GA3323@pingi.kke.suse.de>
	<462A0CA7.2090908@imap.cc>
	<20070421215844.542d3aab@the-village.bc.nu>
	<20070421.151052.78709111.davem@davemloft.net>
	<462B54A0.9000203@imap.cc>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> If it isn't obsolete then fix the code to use the newer APIs
> 
> Why should that be a precondition for removing the incorrect
> "obsolete" label?

Because if we remove the obsolete label the users are going to be
suprised when it goes away entirely with && BROKEN or && !HOTPLUG or
similar.

> >> to end up && BROKEN let alone Obsolete.
> 
> That can't happen. Any change that breaks isdn4linux before its
> replacement is ready would constitute a regression.
> We've been there once, remember?

Want to be on that. There is nobody maintaining it. That isn't a
sustainable situation so it will break.

> I beg to differ. Existence of a working replacement is exactly
> the criterion we arrived at when discussing the meaning of the
> term "obsolete". So lack of a working replacement *is* an
> argument for concluding that something is not obsolete.

Ok then it should be marked "BROKEN" instead.

> - The authors of certain in-kernel API changes seem to have
>   neglected the isdn4linux subsystem in their work.

For simile changes they have kept it going (eg the tty changes), but the
code is too big and too messy for that to happen for all things. Thus
it will eventually break

> - These are two independent problems. Blocking the correction of
>   one of them because the other one still exists doesn't help,
>   but only risks deadlock.

No risk of deadlock. It'll progress to && BROKEN which will either cause
sufficient pain for someone to get off their arse and fix it, for enough
of a vendors users to get the vendor to do the work or for someone who
cares to pay a third party to do the work.

Alan
