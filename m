Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbXDYVbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbXDYVbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 17:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbXDYVb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 17:31:26 -0400
Received: from [212.12.190.171] ([212.12.190.171]:33143 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754276AbXDYVbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 17:31:24 -0400
From: Al Boldi <a1426z@gawab.com>
To: Pavel Machek <pavel@ucw.cz>, William Heimbigner <icxcnika@mar.tar.cc>
Subject: Re: Reasons to merge suspend2.
Date: Thu, 26 Apr 2007 00:33:22 +0300
User-Agent: KMail/1.5
Cc: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>, linux-kernel@vger.kernel.org
References: <200704251551.38373.a1426z@gawab.com> <Pine.LNX.4.64.0704251600030.25153@server.thyself> <20070425161656.GA17253@elf.ucw.cz>
In-Reply-To: <20070425161656.GA17253@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704260033.22378.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!

Hi!

> > >>I didn't read your whole post, it's way too long, but I would like to
> > >> see your patch in mainline as an option to swsusp.  What would make
> > >> this infeasible?
> > >
> > >For one thing, Linus said not but yesterday that he doesn't want
> > > multiple competing suspend algorithms like this in the kernel at once.
> > > (If I parsed his message correctly, he doesn't want any in the kernel,
> > > but he's putting up with it because it seems somewhat needed.)
> >
> > Would it be a feasible solution to have a very minimal and generic
> > software suspend in the kernel, and then various userspace
> > implementations could take care of this?
>
> Yes please. If you want suspend-over-nfs or whatever, just add it to
> the userspace; we have enough support in kernel now.

The only way I can think of supporting this, would probably be via an 
initramfs trick.  But, if you think suspend-over-nfs is possible from 
user-space, then why should there be any need for swsusp in the kernel?


Thanks!

--
Al

