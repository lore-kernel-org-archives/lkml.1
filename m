Return-Path: <linux-kernel-owner+w=401wt.eu-S1762756AbZJOPA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762756AbZJOPA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 11:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762416AbZJOPA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 11:00:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49705 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762297AbZJOPA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 11:00:57 -0400
Date: Thu, 15 Oct 2009 16:01:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Remove or convert empty ioctls ?
Message-ID: <20091015160109.6d9353e8@lxorguk.ukuu.org.uk>
In-Reply-To: <4AD711BC.2030409@garzik.org>
References: <alpine.LFD.2.00.0910151113340.9428@localhost.localdomain>
	<4AD711BC.2030409@garzik.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> "no particular value" is highly subjective, and I think unprovable, 
> without an exhaustive survey of userland programs interacting with 
> kernel drivers.  Userland programs often interact with a -class- of 
> drivers, expecting predictable behavior from a DoThisThing ioctl, with 
> EINVAL or "other weird error code" returned intentionally.
> 
> Changing the return codes seems quite unwise.

We've changed lots of them to -ENOTTY over the past few years, nobody has
even noticed (you included ;))

SuS says an unknown ioctl code returns -ENOTTY.

Alan
