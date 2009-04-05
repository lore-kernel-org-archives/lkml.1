Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbZDEXKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbZDEXKQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 19:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbZDEXKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 19:10:00 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52099 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466AbZDEXKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 19:10:00 -0400
Message-ID: <49D93A42.2030009@garzik.org>
Date: Sun, 05 Apr 2009 19:09:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Should I choose SLOW_WORK?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am newly presented with


> Enable slow work thread pool (SLOW_WORK) [N/y/?] (NEW) ?
> 
> The slow work thread pool provides a number of dynamically allocated
> threads that can be used by the kernel to perform operations that
> take a relatively long time.
> 
> An example of this would be CacheFiles doing a path lookup followed
> by a series of mkdirs and a create call, all of which have to touch
> disk.


However, this does not tell me whether I need or want this.

And, why must the user make this choice at all?  Surely it can be 
auto-selected, if cachefs is enabled?  At a minimum, hide this under 
CONFIG_EMBEDDED or whatnot, so that most users don't see this choice, IMO.

	Jeff


