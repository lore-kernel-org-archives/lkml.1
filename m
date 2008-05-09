Return-Path: <linux-kernel-owner+w=401wt.eu-S1759457AbYEIXzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457AbYEIXzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 19:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638AbYEIXzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 19:55:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755953AbYEIXzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 19:55:21 -0400
Date: Fri, 9 May 2008 16:55:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: andreas.herrmann3@amd.com, mingo@elte.hu, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: enable hpet=force for AMD SB400
Message-Id: <20080509165501.a0fdb29d.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805100140490.3197@apollo.tec.linutronix.de>
References: <20080509094911.GG5023@alberich.amd.com>
	<20080509163731.5f851bec.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0805100140490.3197@apollo.tec.linutronix.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 May 2008 01:42:30 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Fri, 9 May 2008, Andrew Morton wrote:
> > On Fri, 9 May 2008 11:49:11 +0200
> > Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> > 
> > > x86: enable hpet=force for ATI SB400
> > 
> > Sigh.
> > 
> > > Add quirk to allow forced usage of HPET on ATI SB400.
> > > I stumbled over machines where HPET is enabled but not reported
> > > by BIOS.
> > 
> > Is there no way in which we can probe for or identify this condition,
> > rather than hoping that the user will find out about this boot option?
> 
> I'd love to have a sane solution for that, but looking at the rate of
> HPET wreckage since we increased the usage of HPET I'm happy to have
> this as an opt in thingy.
> 

Well we don't have to auto-enable the hpet.  Simply adding a loud "you
should try the hpet=force option" printk would help a lot of people.

