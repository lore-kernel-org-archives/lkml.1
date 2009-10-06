Return-Path: <linux-kernel-owner+w=401wt.eu-S1758298AbZJFVm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbZJFVm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbZJFVm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:42:56 -0400
Received: from thunk.org ([69.25.196.29]:47052 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbZJFVmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:42:55 -0400
Date: Tue, 6 Oct 2009 17:42:14 -0400
From: Theodore Tso <tytso@mit.edu>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: Massive ext4 filesystem corruption after a failed s2disk/ram
	cycle
Message-ID: <20091006214214.GC17883@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-pm <linux-pm@lists.linux-foundation.org>
References: <1254863215.11577.23.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254863215.11577.23.camel@maxim-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 11:06:55PM +0200, Maxim Levitsky wrote:
> 
> Just prior to 2.6.32 cycle I tried -next tree and noticed that after a
> failed s2ram (here it works only once, and I test once in a whileto see
> if fixed accidentally) I got a minor filesystem corruption. I am sorry I
> didn't report that back then.

When you say filesystem corruption, it's important to indicate whether
you meant that (a) you noticed that some files were had corrupted
contents, (b) the kernel complained that the filesystem was corrupted,
and remounted the filesystem read-only, or (c) e2fsck found and fixed
errors.

Also, when you found errors of either class (a) or (b), did you run
e2fsck to find and fix any potential errors?  In a few places it
sounded like the kernel had complained about errors, but you had
ignored them and hadn't run e2fsck to fix them.  I hope that was just
me misunderstanding what you wrote!  Can you clarify?

   		    	     	     	     - Ted
