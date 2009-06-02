Return-Path: <linux-kernel-owner+w=401wt.eu-S1756756AbZFBAca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbZFBAca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 20:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbZFBAcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 20:32:22 -0400
Received: from bhuna.collabora.co.uk ([93.93.131.97]:40392 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbZFBAcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 20:32:21 -0400
X-Greylist: delayed 1436 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jun 2009 20:32:21 EDT
Date: Mon, 1 Jun 2009 20:08:21 -0400
From: Andres Salomon <dilinger@collabora.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tobias_Mueller@twam.info, david-b@pacbell.net, jordan@cosmicpenguin.net,
       gardner.ben@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 001/001] gpio: AMD CS5535/CS5536 GPIO driver
Message-ID: <20090601200821.62b04e43@mycelium.queued.net>
In-Reply-To: <20090601165457.a1cc1025.akpm@linux-foundation.org>
References: <17be05570905230453i591eb83bnb359f6365c109718@mail.gmail.com>
	<20090526151621.a7446c60.akpm@linux-foundation.org>
	<17be05570905301105h395689ja33afa96e7751381@mail.gmail.com>
	<20090601165457.a1cc1025.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jun 2009 16:54:57 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:
[...]
> 
> Back in February, Andres sent out a patch "cs553x-gpio: add AMD
> CS5535/CS5536 GPIO driver support".  AFACIT that patch does the same
> thing that this one does, but differently.  IIRC it had a great string
> of weird-Kconfig-related build errors and I eventually dropped it.
> 
> What's the story here?
> 
> Thanks.

My story is that I've since switched employers twice since Feb, and will
be resubmitting the patch now that sanity has returned to my life.
I'm planning to get to it within the next week.

As far as Tobias's driver, one major difference between our drivers is
that mine doesn't grab the entire PCI device.  This is because other
drivers (ie, the MFGPT driver) will want to share the PCI device.
