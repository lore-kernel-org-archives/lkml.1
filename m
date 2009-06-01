Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbZFAXzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbZFAXzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 19:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbZFAXzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 19:55:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753440AbZFAXzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 19:55:38 -0400
Date: Mon, 1 Jun 2009 16:54:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tobias_Mueller@twam.info
Cc: david-b@pacbell.net, jordan@cosmicpenguin.net, gardner.ben@gmail.com,
       linux-kernel@vger.kernel.org, Andres Salomon <dilinger@queued.net>
Subject: Re: [PATCH v2 001/001] gpio: AMD CS5535/CS5536 GPIO driver
Message-Id: <20090601165457.a1cc1025.akpm@linux-foundation.org>
In-Reply-To: <17be05570905301105h395689ja33afa96e7751381@mail.gmail.com>
References: <17be05570905230453i591eb83bnb359f6365c109718@mail.gmail.com>
	<20090526151621.a7446c60.akpm@linux-foundation.org>
	<17be05570905301105h395689ja33afa96e7751381@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 May 2009 20:05:52 +0200
Tobias M__ller <Tobias_Mueller@twam.info> wrote:

> From: Tobias Mueller <Tobias_Mueller@twam.info>
> 
> A GPIO driver for AMD Geode Companion Device CS5535/CS5536
> using the GPIO framework as a replacement for old cs5535-gpio driver.
> Signed-off-by: Tobias Mueller <Tobias_Mueller@twam.info>

Last time, I said "We'll need to discuss the migration plan - we don't
want to maintain two drivers for the same thing".

Back in February, Andres sent out a patch "cs553x-gpio: add AMD
CS5535/CS5536 GPIO driver support".  AFACIT that patch does the same
thing that this one does, but differently.  IIRC it had a great string
of weird-Kconfig-related build errors and I eventually dropped it.

What's the story here?

Thanks.
