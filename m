Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbZKIMJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbZKIMJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 07:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbZKIMJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 07:09:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820AbZKIMJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 07:09:40 -0500
Date: Mon, 9 Nov 2009 17:38:39 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Anthony Liguori <aliguori@us.ibm.com>, linux-kernel@vger.kernel.org,
       virtualization@linux-foundation.org,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v10 1/1] virtio_console: Add support for multiple ports
	for generic guest and host communication
Message-ID: <20091109120839.GA11256@amit-x200.redhat.com>
References: <1257266319-24300-1-git-send-email-amit.shah@redhat.com> <1257266319-24300-2-git-send-email-amit.shah@redhat.com> <200911061740.03734.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911061740.03734.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Rusty,

On (Fri) Nov 06 2009 [17:40:02], Rusty Russell wrote:
> On Wed, 4 Nov 2009 03:08:39 am Amit Shah wrote:
> > Expose multiple char devices ("ports") for simple communication
> > between the host userspace and guest.
> 
> OK, I've taken the chance to audit this patch.  I started adding patches
> until I got overwhelmed.   It's a complete mess and needs a total rewrite :(
> 
> This shows the problem with feeding me a complete driver rewrite in one
> big hit.  You've combined lots of changes and techniques in here at once:

I'm really sorry for dumping this all at once.

I've separated out the patches for easier reviewing, the result passes
my tests but I'm going to give them some more time to run.

> Less important nitpicks:

...

> 3) Don't use list_for_each_safe() to get the head entry of a list.  Your
>    use is buggy anyway: buf will never be NULL afterwards.

As long as 'head' isn't the only node in the list we should loop. And
list_foreach_safe() does that. So it's OK right?

> In summary: this is the one we're going to throw away.
> 
> Now I'm going to start again, one patch at a time, and see how that works.

I'm sorry for having created more work for you; I'll send out my patches
to you in a couple of days.

Thanks!
		Amit
