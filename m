Return-Path: <linux-kernel-owner+w=401wt.eu-S1762475AbXEUPqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762475AbXEUPqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 11:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756360AbXEUPqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 11:46:06 -0400
Received: from smtp.osdl.org ([207.189.120.12]:55043 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380AbXEUPqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 11:46:05 -0400
Date: Mon, 21 May 2007 08:45:49 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Mike Houston <mikeserv@bmts.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc2
Message-ID: <20070521084549.61a1aa71@freepuppy>
In-Reply-To: <20070520170506.814a38d9.mikeserv@bmts.com>
References: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org>
	<20070520170506.814a38d9.mikeserv@bmts.com>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007 17:05:06 -0400
Mike Houston <mikeserv@bmts.com> wrote:

> On Fri, 18 May 2007 22:17:14 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> 
> > Stephen Hemminger (7):
> >       [TCP] slow start: Make comments and code logic clearer.
> >       *** sky2: remove Gigabyte 88e8056 restriction ***
> >       sky2: PHY register settings
> >       sky2: keep track of receive alloc failures
> >       sky2: MIB counter overflow handling
> >       sky2: remove dual port workaround
> >       sky2: memory barriers change
> >
> 
> I tested this and it's still horribly broken for me with Gigabyte
> 88E8056 onboard LAN. Same symptom as before, it works for several
> seconds and then dies.

It's almost certainly a problem with the BIOS and hardware (not a sky2)
driver issue. Since there are many similar boards and configurations, I made
the decision not to enforce restrictions in the driver.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
