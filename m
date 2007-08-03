Return-Path: <linux-kernel-owner+w=401wt.eu-S1758997AbXHCG0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997AbXHCG0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 02:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbXHCG0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 02:26:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35614 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751638AbXHCG0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 02:26:10 -0400
Date: Thu, 2 Aug 2007 23:25:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Keith Owens <kaos@sgi.com>
Cc: vgoyal@in.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Takenori Nagano <t-nagano@ah.jp.nec.com>, k-miyoshi@cb.jp.nec.com,
       Bernhard Walle <bwalle@suse.de>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] add kdump_after_notifier
Message-Id: <20070802232502.b93f4ea0.akpm@linux-foundation.org>
In-Reply-To: <31687.1186113947@kao2.melbourne.sgi.com>
References: <20070802112852.GA7054@in.ibm.com>
	<31687.1186113947@kao2.melbourne.sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Aug 2007 14:05:47 +1000 Keith Owens <kaos@sgi.com> wrote:

> I have pretty well given up on RAS code in the Linux kernel.  Everybody
> has different ideas, there is no overall plan and little interest from
> Linus in getting RAS tools into the kernel.  We are just thrashing.

Lots of different groups, little commonality in their desired funtionality,
little interest in sharing infrastructure or concepts.  Sometimes people
need a bit of motivational help.

In this case that motivation would come from the understanding that all the
RAS tools would be *required* to use such infrastructure if it was merged. 
Going off and open-coding your own stuff would henceforth not be acceptable.
If it turns out that it really was unsuitable for a particular group's RAS
feature, and we merged it anyway, well, that mismatch is that group's
fault.

It was a sizeable mistake to send those patches to a few obscure mailing
lists - this is the first I've heard of it, for example.

So.  Please, send it all again, copy the correct lists and people, make sure
that at least one client of the infrastructure is wired up and working (ideally,
all such in-kernel clients should be wired up) and let's take a look at it.

Much of the onus is upon the various RAS tool developers to demonstrate why it
is unsuitable for their use and, hopefully, to explain how it can be fixed for
them.

