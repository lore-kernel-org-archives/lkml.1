Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbYDGW3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbYDGW3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 18:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbYDGW3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 18:29:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753010AbYDGW3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 18:29:07 -0400
Date: Mon, 7 Apr 2008 15:28:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: cooloney@kernel.org, torvalds@linux-foundation.org, davem@davemloft.net,
       linux-kernel@vger.kernel.org, magnus.damm@gmail.com, damm@igel.co.jp,
       lethal@linux-sh.org, nico@cam.org, vapier.adi@gmail.com
Subject: Re: Blackfin STAMP537 compiling error in 2.6.25-rc8
Message-Id: <20080407152800.1a8e37fc.akpm@linux-foundation.org>
In-Reply-To: <47FA813D.6090505@garzik.org>
References: <386072610804070057w1eb65db5taeca77f8f3e36627@mail.gmail.com>
	<47F9D7BA.6080708@garzik.org>
	<386072610804070115s57dfd49fgad01218e820167b@mail.gmail.com>
	<47FA813D.6090505@garzik.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Apr 2008 16:17:01 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Since it was an arch patch to a driver I cannot build, I made the 
> [mistaken] assumption that your sending it to me was an indication that 
> it should actually be merged :)  Especially with a subject like "fix 
> build breakage", for a platform I cannot easily build...
> 
> Are there any process tweaks that could be made here?  Maybe -mm stuff 
> sent to maintainers could be tagged, noting dependencies on other -mm 
> patches that are not yet upstream?

Well.  It really helps if submitters tell us that a patch fixes another
pending patch, and which one that is.  Usually Ihave to ask if I can't work
it out.


But if a) we weren't told that and b) I have no reason to think it's not a
mainline problem and c) the patch applies to mainline and d) the patch
affects an architecture which I'm not cross-compiling for, it's going to
sneak through.

Fortunately, a && b && c && d doesn't happen at all often.
