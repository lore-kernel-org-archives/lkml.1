Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbYIVPgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbYIVPgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 11:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYIVPgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 11:36:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:56306 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbYIVPgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 11:36:10 -0400
Date: Mon, 22 Sep 2008 08:34:55 -0700
From: Greg KH <greg@kroah.com>
To: Benjamin Thery <benjamin.thery@bull.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: sysfs: tagged directories not merged completely yet
Message-ID: <20080922153455.GA6238@kroah.com>
References: <48D7AC44.6050208@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D7AC44.6050208@bull.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 04:31:32PM +0200, Benjamin Thery wrote:
> Hi Greg,
>
> Someone made me notice that Eric's "sysfs tagged directories" patchset
> you merged recently  isn't complete in your "patches" tree. The last two
> patches that actually uses this new feature aren't in your tree yet.
>
> * [PATCH 7/8] netns: Enable tagging for net_class directories in sysfs
> * [PATCH 8/8] sysfs: user namespaces: fix bug with clone(CLONE_NEWUSER)	
> with fairsched
>
> I didn't noticed it sooner because I'm still using my own version of the
> patchset on top of linux-2.6.
>
> I'm wondering why you left these two patches out? Is it on purpose? Do
> you expect other maintainers to merged them in their respective tree?
> Dave Miller acked the patch for network namespace and said "You can send
> it all through Greg or whoever, don't feel obligated to push it through
> me since it depends upon the earlier bits in this series".

I only got so far through the patch set and then got interrupted (was at
different conferences for 2 weeks), sorry.  I'll get the rest of the
patchset added later today.

Note, I did talk to Al Viro about these patches last week at the kernel
summit, and he advised holding off on sending them to mainline before he
could review them.  So I'll keep them in my tree for now, but not push
them to Linus until he acks them as he raised a few issues in our
conversation.

thanks,

greg k-h
