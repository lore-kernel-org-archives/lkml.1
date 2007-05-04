Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbXEDOe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbXEDOe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 10:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbXEDOe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 10:34:28 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:21762 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355AbXEDOe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:34:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=TPiFsqGNBA4A+WWfOh3zHb+dstVW2w6/dqnH6s3WOiiB63NCmEs0z2zPul6VzFN+2fW9SX3KoWIWQk0w1hKIrpB7Q829/AzdwMcVrT8yHhdQnLZydDQtR/QukiB7d0d02nh1n2VlcZp8CngvXSyDKv7gge136oN5aEJV9BDEMyc=
Date: Fri, 4 May 2007 16:33:26 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Strange soft lockup detected message (looks like spin_lock bug in pcnet32)
Message-ID: <20070504143326.GD24769@slug>
References: <20070503203143.GA8753@csclub.uwaterloo.ca> <20070504141024.GB8753@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070504141024.GB8753@csclub.uwaterloo.ca>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 10:10:24AM -0400, Lennart Sorensen wrote:
> On Thu, May 03, 2007 at 04:31:43PM -0400, Lennart Sorensen wrote:
[...]
> Should line 2563 be a spin_lock_irqsave instead along with the
> appropriate unluck later?
IIRC, when you enable lockdep, it will complain about spinlocks used in
an invalid context.

Regards,
Frederik
> 
> --
> Len Sorensen
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
