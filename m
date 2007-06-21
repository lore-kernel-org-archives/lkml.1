Return-Path: <linux-kernel-owner+w=401wt.eu-S1752513AbXFUXCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbXFUXCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750922AbXFUXBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:01:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41647 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750724AbXFUXBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:01:53 -0400
Date: Thu, 21 Jun 2007 16:01:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-06-20-10-12.tar.gz uploaded
Message-Id: <20070621160135.f5bcd428.akpm@linux-foundation.org>
In-Reply-To: <4679F17E.4060305@goop.org>
References: <200706201714.l5KHEYh6010297@imap1.linux-foundation.org>
	<4679F17E.4060305@goop.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 20 Jun 2007 20:33:18 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> akpm@linux-foundation.org wrote:
> > git-r8169-fixup.patch
> >   
> This causes a compile failure:
> 
> /home/jeremy/hg/xen/paravirt/linux/drivers/net/r8169.c: In function 'rtl8169_rx_interrupt':
> /home/jeremy/hg/xen/paravirt/linux/drivers/net/r8169.c:2569: error: too many arguments to function 'rtl8169_try_rx_copy'
> 
> with an allyesconfig on x86-64.  Should git-r8169-fixup.patch also be 
> changing the callers?
> 

git-r8169-fixup is a fix for git-r8169, which I'd in fact dropped, so
it should't be there at all.

Sorry, that was just a heading-for-the-airport-quick-dump-my-queue
thing.  I have some serious catching up to do.
