Return-Path: <linux-kernel-owner+w=401wt.eu-S1762816AbXJZCOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762816AbXJZCOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 22:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbXJZCOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 22:14:40 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:46554 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082AbXJZCOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 22:14:39 -0400
Date: Thu, 25 Oct 2007 20:14:37 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Remove #warnings for longstanding conditions.
Message-ID: <20071026021437.GQ27248@parisc-linux.org>
References: <a576b5944eb04a18d4df3dd27cd32e7f13601470.1193299380.git.jeff@garzik.org> <03231528cf69b4194111178db23a7a387a573cb7.1193299380.git.jeff@garzik.org> <20071025112231.GL27248@parisc-linux.org> <47214BD5.4020106@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47214BD5.4020106@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 10:07:17PM -0400, Jeff Garzik wrote:
> Is this warning of value to anybody but you?

Yup.  It signals this driver isn't production quality yet.

> Is this information worth printing out on everyone else's kernel build?

I thnk that's worth noting to anyone who's enabled it.

> If yes, great!  But it sounds like this warning is analagous to
> 
>   #warning willy's TODO list: get milk, buy groceries, read email, ...
> 
> which doesn't add much value to others' kernel builds :)

I didn't add the #warning; it was there before 2.6.12-rc2.  I haven't
added warnings for anything else on the todo list (which remains
mightily long, but I'm acually crossing things off it rather than just
adding to it now).

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
