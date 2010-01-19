Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882Ab0ASWj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab0ASWj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 17:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829Ab0ASWj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 17:39:56 -0500
Received: from 1wt.eu ([62.212.114.60]:54844 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859Ab0ASWjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 17:39:55 -0500
Date: Tue, 19 Jan 2010 23:31:37 +0100
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: Stable kernel tree status, January 18, 2010
Message-ID: <20100119223137.GA4408@1wt.eu>
References: <20100118190939.GA26189@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118190939.GA26189@kroah.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 11:09:39AM -0800, Greg KH wrote:
> Here's the state of the -stable kernel trees, as of January 18, 2010.
> 
> 2.6.27-stable
> 
> The 2.6.27-stable kernel tree is still living on, as a "long-term"
> stable release.  But, I do have to warn users of this tree, the older it
> gets, the less viable it becomes.  Not all bugfixes are being backported
> to this kernel version due to massive code changes in the over 2 years
> since this kernel has been released.  I am doing my best to backport
> fixes that I become aware of, and I encourage anyone who does fix any
> types of bugs in the main kernel tree to let me know if the change
> should be applied to this older kernel version.
> 
> I'll probably keep maintaining it for at least 6-8 more months, but
> after that, I can not guarantee it's viability.  Note, one other
> developer has volunteered to pick up the tree after I am finished with
> it, but I can not speak for him at this time.

I can confirm that I proposed to Greg to take it up to give time to
users to switch to newer releases. BUT it is important to understand
that it will then considerably slow down, basically just like 2.4,
with one release every few months when a major issue has to be fixed.
This is simply because I cannot spend as much time as Greg on that
task. Right now I pick most of the 2.4 fixes from Greg's patches that
I backport, so that should not change much with another kernel. However
Greg's rule above still applies : if a fix cannot easily be backported,
better drop it than break everything else.

For this reason, the kernel will eventually become obsolete, and
everyone should consider migrating to 2.6.32-stable.

BTW, thanks Greg for doing that again with 2.6.32. I hope that your
early announcement will incite more people to adopt it so that many
regressions are quickly spotted and fixed.

Regards,
Willy

