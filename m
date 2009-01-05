Return-Path: <linux-kernel-owner+w=401wt.eu-S1753238AbZAEJNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbZAEJNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:13:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbZAEJMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:12:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751726AbZAEJMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:12:49 -0500
Date: Mon, 5 Jan 2009 01:12:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 -mm merge plans
Message-Id: <20090105011202.835e75ec.akpm@linux-foundation.org>
In-Reply-To: <20090105090239.GB17530@uranus.ravnborg.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	<20090105090239.GB17530@uranus.ravnborg.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009 10:02:39 +0100 Sam Ravnborg <sam@ravnborg.org> wrote:

> Hi Andrew.
> 
> > sparc64-use-unsigned-long-long-for-u64.patch
> > sparc64-fix-unsigned-long-long-warnings-in-drivers.patch
> 
> Please drop these two.

Might, if they break my build.

> They are not complete (break build on certain configurations).
> I will get back to them when I get my sparc64 setup functional.

I tend to hang onto things I like, even if they aren't right yet.

We really really need to push ahead with fixing this stuff.  Because of
this problem the number of bugs which people are adding, and the number
of subsequent fixup patches (ALL of which are fugly and stupid) is just
out of control, and quite unnecessary.

Maybe we should just do the switch, send best-effort fixup patches at
the arch maintainers and move on.
