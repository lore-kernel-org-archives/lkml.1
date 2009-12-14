Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbZLNKjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbZLNKjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 05:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723AbZLNKji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 05:39:38 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:48177 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625AbZLNKji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 05:39:38 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
Date: Mon, 14 Dec 2009 11:39:48 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
References: <20091212101032.GB25286@elte.hu> <20091213191606.GB7297@nowhere> <20091213213015.653307b5@infradead.org>
In-Reply-To: <20091213213015.653307b5@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912141139.48115.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 14. Dezember 2009 06:30:15 schrieb Arjan van de Ven:
> > We have the bkl tracepoints for that, attaching an example below,
> > blkdev_get/bkldev_put is among the highest consumer for me.
> 
> we have a trace, but not a number that anyone can just pull out without
> having to go through great lengths to set stuff up... (esp to capture a
> boot)...
> Adding a counter always to the lock_kernel function should be fine
> instead...

But don't we need to know how long it is held? If you just count
you'll make code that drops it while it can look bad.

	Regards
		Oliver
