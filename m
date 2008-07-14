Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbYGNMIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbYGNMIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 08:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbYGNMI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 08:08:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58194 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbYGNMI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 08:08:27 -0400
Date: Mon, 14 Jul 2008 05:04:18 -0700
From: Greg KH <greg@kroah.com>
To: pageexec@freemail.hu
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
Message-ID: <20080714120418.GA5334@kroah.com>
References: <20080703185727.GA12617@suse.de> <486D4541.25808.C600354@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486D4541.25808.C600354@pageexec.freemail.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay, was on vacation...

On Thu, Jul 03, 2008 at 09:31:45PM +0200, pageexec@freemail.hu wrote:
> [spender's asked to be off the CC]

Chicken :)

> On 3 Jul 2008 at 11:57, Greg KH wrote:
> 
> > On Thu, Jul 03, 2008 at 10:29:14AM -0700, Greg KH wrote:
> > Adding 2 more addresses to this thread, as they were said to have
> > questions about this kernel release.
> 
> not only this one, but every commit for the past few years that fixed
> bugs with security impact. for reference:
> 
> http://lwn.net/Articles/285438/
> http://lwn.net/Articles/286263/
> http://lwn.net/Articles/287339/
> http://lwn.net/Articles/288473/

As I'm somewhere there is no web access, mind summarizing these if they
are relevant?

> > Again, if the above information is somehow insufficient as to what
> > exactly is fixed in the -stable releases, and anyone has questions about
> > how these release announcements are created, please let me know.
> 
> what is the disclosure policy used for commits fixing bugs with security
> impact (both vanilla and -stable, especially if there's a difference)?

What is outlined in Documentation/SecurityBugs.

> what do you include/omit?

Personally, I omit posting full "and here is explicitly how to exploit
this problem" notices as that is foolish.

But also remember that -stable releases are just a compilation of
patches that developers have sent to the stable developers, we use the
original commit messages as published in the main kernel tree, except
where the patch differs, which is rare.  So it's not like these releases
are any different than the main kernel releases on descriptions of
patches and issues surrounding them.

> how does it relate to what is declared in Documentation/SecurityBugs?

That deals with how security bugs that are sent to security@kernel.org
are handled, which is totally different from -stable releases, right?

thanks,

greg k-h
