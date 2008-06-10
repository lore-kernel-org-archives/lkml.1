Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbYFJTLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbYFJTLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 15:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbYFJTL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 15:11:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753053AbYFJTLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 15:11:25 -0400
Date: Tue, 10 Jun 2008 12:10:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Greg KH <greg@kroah.com>, Oliver Neukum <oliver@neukum.org>,
       Pavel Machek <pavel@suse.cz>, USB list <linux-usb@vger.kernel.org>,
       Andrew Morton <akpm@linuxfoundation.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] USB: don't use reset-resume if drivers don't support
 it
In-Reply-To: <Pine.LNX.4.44L0.0806101454480.3658-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.1.10.0806101209180.3101@woody.linux-foundation.org>
References: <Pine.LNX.4.44L0.0806101454480.3658-100000@iolanthe.rowland.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 10 Jun 2008, Alan Stern wrote:
> 
> This is only a temporary fix.  Later on we will explicitly unbind
> drivers that can't handle reset-resumes.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

And feel free to add my signed-off on it too, assuming somebody who saw 
the problems has actually tested it.

And thanks for picking up the fix and creating an updated patch.

		Linus
