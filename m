Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbZDEXd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbZDEXd2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 19:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbZDEXdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 19:33:19 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21827 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZDEXdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 19:33:18 -0400
Date: Mon, 6 Apr 2009 01:33:16 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Jeff Garzik <jeff@garzik.org>
cc: David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Should I choose SLOW_WORK?
In-Reply-To: <49D93A42.2030009@garzik.org>
Message-ID: <alpine.LNX.2.00.0904060130300.20641@swampdragon.chaosbits.net>
References: <49D93A42.2030009@garzik.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Apr 2009, Jeff Garzik wrote:

> I am newly presented with
> 
> 
> > Enable slow work thread pool (SLOW_WORK) [N/y/?] (NEW) ?
> > 
> > The slow work thread pool provides a number of dynamically allocated
> > threads that can be used by the kernel to perform operations that
> > take a relatively long time.
> > 
> > An example of this would be CacheFiles doing a path lookup followed
> > by a series of mkdirs and a create call, all of which have to touch
> > disk.
> 
> 
> However, this does not tell me whether I need or want this.
> 
> And, why must the user make this choice at all?  Surely it can be
> auto-selected, if cachefs is enabled?  At a minimum, hide this under
> CONFIG_EMBEDDED or whatnot, so that most users don't see this choice, IMO.
> 

I very much agree. I was confused by that option as well when I first saw 
it and the help text didn't really help much in determining if I wanted it 
or not.
If it's something that's generally useful, the kernel should just 
enable/use it. If other things depend on it they should auto-select it.


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

