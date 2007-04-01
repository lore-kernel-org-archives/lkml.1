Return-Path: <linux-kernel-owner+w=401wt.eu-S933599AbXDAQSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599AbXDAQSG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 12:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933591AbXDAQSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 12:18:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933605AbXDAQSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 12:18:04 -0400
Date: Sun, 1 Apr 2007 09:16:10 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Jiri Kosina" <jkosina@suse.cz>, dtor@insightbb.com,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       stuart_hayes@dell.com
Subject: Re: usb hid: reset NumLock
Message-Id: <20070401091610.46fa1ddb.zaitcev@redhat.com>
In-Reply-To: <84144f020704010449w2ba342a3qf3025425e84ad2ce@mail.gmail.com>
References: <20070330105924.01a16dd6.zaitcev@redhat.com>
	<84144f020704010449w2ba342a3qf3025425e84ad2ce@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2007 14:49:59 +0300, "Pekka Enberg" <penberg@cs.helsinki.fi> wrote:
> On 3/30/07, Pete Zaitcev <zaitcev@redhat.com> wrote:

> > Dell people (Stuart and Charles) complained that on some USB keyboards,
> > if BIOS enables NumLock, it stays on even after Linux has started. Since
> > we always start with NumLock off, this confuses users. Quick double dab
> > at NumLock fixes it, but it's not nice.
> 
> What I am seeing on my Thinkpad is that when I boot _without_ an USB
> keyboard NumLock is enabled. Switching to virtual console and back to
> X fixes it which is why I have never bothered to debug it further.
> Perhaps this is related? Should I give your patch a spin to see if it
> fixes the problem?

It's related, but not the same problem. Perhaps the initialization in atkbd
which Dmitry mentioned is not complete. Jiri found a fatal bug in my patch,
but even assuming that it worked, it still would do nothing to you.

-- Pete
