Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbYCLW3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbYCLW3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755833AbYCLW3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:29:19 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:33359 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755812AbYCLW3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:29:17 -0400
Date: Thu, 13 Mar 2008 01:28:23 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] signals: fold sig_ignored() into handle_stop_signal()
Message-ID: <20080312222823.GA131@tv-sign.ru>
References: <20080312123311.GA13478@tv-sign.ru> <20080312215848.606F726F992@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312215848.606F726F992@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12, Roland McGrath wrote:
>
> This one looks fine to me.  I would like the comment above the function to
> be updated to describe its new purpose, and to document its return value's
> meaning.

Will do.

> Also, I'm not sure if there is a kernel code formatting convention that
> particularly excludes an empty block ({}, equiv to ;) containing just
> comments.  But I don't recall seeing that style used in the kernel.
> (I don't mind it personally for this case given what the obvious
> alternatives would look like.)

Yes, this looks a bit unusual... but I can't see how it is possible to
make it simpler (without goto's or duplication the code).

> > A couple of small comments about how CLD_CONTINUED notification works.
>
> I would make the get_signal_to_deliver comment say a
> little more.  In particular, it's kind of nonobvious that though this
> happens at the beginning of the function, the importance of its placement
> is really that it will always be run (via the relock: loop) just after any
> wake-up from having been in TASK_STOPPED.

Will do, thanks.

Oleg.

