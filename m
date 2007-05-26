Return-Path: <linux-kernel-owner+w=401wt.eu-S1763531AbXEZQVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763531AbXEZQVd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 12:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763191AbXEZQVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 12:21:24 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:42729
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762798AbXEZQVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 12:21:23 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Sat, 26 May 2007 18:21:16 +0200
User-Agent: KMail/1.9.6
Cc: Uwe Bugla <uwe.bugla@gmx.de>, Maximilian Engelhardt <maxi@daemonizer.de>,
       linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <20070524195616.234280@gmx.net> <200705261750.48816.mb@bu3sch.de> <20070526091309.0af20971.akpm@linux-foundation.org>
In-Reply-To: <20070526091309.0af20971.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705261821.16355.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 May 2007 18:13:09 Andrew Morton wrote:
> > I already tried your -mm kernel, but it crashes on my machine
> > for other reasons. (Yeah, I should look into them, too :P )
> 
> err, please do.  Just the oops trace would be a start.

Yes, I will look into it. I think it was related to my
onboard RTL networking chip. When trying to bring it down,
it oopses the machine. But I'm not sure what happens exactly, yet.
I'll take a look at it.

> > Andrew, is it possible that the breakage was introduced in the
> > merge process somehow? Didn't the patch apply cleanly? Are there
> > other changes to b44 I should know about in your tree?
> 
> Only git-wireless.net modifies b44.c but if we're having IRQ assignment
> problems then we'd need to look elsewhere.

I think we don't have IRQ assignment problems. Uwe simply disabled
b44-PCI support in his first bugreport (I guess). So there was
no b44-PCI driver loaded.
Later on he said that it does magically work now...

-- 
Greetings Michael.
