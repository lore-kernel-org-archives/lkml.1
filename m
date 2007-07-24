Return-Path: <linux-kernel-owner+w=401wt.eu-S932204AbXGXUGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbXGXUGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764043AbXGXUFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:05:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:25537 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133AbXGXUFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:05:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=WdNn5rD3G8pfEZMCD9nQahPaKco3lJQSYcosAOPvNd2FdjkXcD5IgCU+ZIKNRrC9QUyFyNRKFp7QWgDUKqVhELABJ2d9vHfR+0dfM02jJLyCTIbKDaQJpWH2UTG5GwEcUJgdpqCA5xMTt9ni43KN3mn/78D2yLHjA/oLpyuITs0=
Date: Wed, 25 Jul 2007 00:05:28 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: 2.6.23-rc1: BUG_ON in kmap_atomic_prot()
Message-ID: <20070724200528.GA5814@martell.zuzino.mipt.ru>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <20070723183839.GA5874@martell.zuzino.mipt.ru> <20070723190152.GA5755@martell.zuzino.mipt.ru> <20070723132431.42afbae8.akpm@linux-foundation.org> <1185271269.6479.7.camel@Homer.simpson.net> <20070724092839.f0556948.akpm@linux-foundation.org> <alpine.LFD.0.999.0707241124220.3607@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707241124220.3607@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 11:25:22AM -0700, Linus Torvalds wrote:
> On Tue, 24 Jul 2007, Andrew Morton wrote:
> > I guess this was the bug:
>
> Looks very likely to me. Mike, Alexey, does this fix things for you?

Yeah, box is running for more than hour, survived LTP, gdb testsuite,
portage sync and so on.

What new to me is that someone decided TSC is unstable but that's
probably OK on full debug kernel:

	Clocksource tsc unstable (delta = 91724418 ns)
	Time: pit clocksource has been installed.

