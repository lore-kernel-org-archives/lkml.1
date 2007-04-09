Return-Path: <linux-kernel-owner+w=401wt.eu-S965564AbXDIVA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965564AbXDIVA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbXDIVA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:00:56 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:34849 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbXDIVAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:00:55 -0400
Subject: Re: [RFC][PATCH -mm] swsusp: Use rbtree for tracking allocated swap
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200704091503.57424.rjw@sisk.pl>
References: <200704072320.40238.rjw@sisk.pl>
	 <200704081847.16738.rjw@sisk.pl>
	 <1176066445.10725.123.camel@nigel.suspend2.net>
	 <200704091503.57424.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 10 Apr 2007 07:00:52 +1000
Message-Id: <1176152452.10245.42.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2007-04-09 at 15:03 +0200, Rafael J. Wysocki wrote:
> On Sunday, 8 April 2007 23:07, Nigel Cunningham wrote:
> [--snip--]
> > > > Normal usage in both cases is simply iterating through the list, so I
> > > > guess the cost would be approximately the same.
> > > > 
> > > > Deletion could would include rebalancing for the rb_nodes.
> > > 
> > > In swsusp the deletions are needed only if there's an error.
> > 
> > When freeing swap at the end of the cycle?
> 
> That depends on what you mean by 'the end'. :-)
> 
> We free swap if the image saving fails only, since it's allocated after we've
> created the image.  After the resume, the state of swap from before the image
> creation is the current one anyway.

Ah, of course. I forgot that temporarily.

Nigel

