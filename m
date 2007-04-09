Return-Path: <linux-kernel-owner+w=401wt.eu-S1751673AbXDINA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbXDINA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 09:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbXDINA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 09:00:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54493 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbXDINAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 09:00:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: [RFC][PATCH -mm] swsusp: Use rbtree for tracking allocated swap
Date: Mon, 9 Apr 2007 15:03:56 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>
References: <200704072320.40238.rjw@sisk.pl> <200704081847.16738.rjw@sisk.pl> <1176066445.10725.123.camel@nigel.suspend2.net>
In-Reply-To: <1176066445.10725.123.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704091503.57424.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 8 April 2007 23:07, Nigel Cunningham wrote:
[--snip--]
> > > Normal usage in both cases is simply iterating through the list, so I
> > > guess the cost would be approximately the same.
> > > 
> > > Deletion could would include rebalancing for the rb_nodes.
> > 
> > In swsusp the deletions are needed only if there's an error.
> 
> When freeing swap at the end of the cycle?

That depends on what you mean by 'the end'. :-)

We free swap if the image saving fails only, since it's allocated after we've
created the image.  After the resume, the state of swap from before the image
creation is the current one anyway.

Greetings,
Rafael
