Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbYCJLHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbYCJLHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 07:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbYCJLHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 07:07:39 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47603 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbYCJLHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 07:07:38 -0400
Date: Mon, 10 Mar 2008 11:29:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Paul Clements <paul.clements@steeleye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       nbd-general@lists.sourceforge.net,
       Laurent Vivier <Laurent.Vivier@bull.net>
Subject: Re: [PATCH 1/1] NBD: allow nbd to be used locally
Message-ID: <20080310102917.GA27751@elf.ucw.cz>
References: <47D468F0.8000506@steeleye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D468F0.8000506@steeleye.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This patch allows a Network Block Device to be mounted locally (nbd-client 
> to nbd-server over 127.0.0.1).
>
> It creates a kthread to avoid the deadlock described in NBD tools 
> documentation. So, if nbd-client hangs waiting for pages, the kblockd 
> thread can continue its work and free pages.

What happens if your new kthread blocks on memory allocation?
									Pavel-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
