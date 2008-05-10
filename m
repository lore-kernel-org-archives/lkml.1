Return-Path: <linux-kernel-owner+w=401wt.eu-S1760577AbYEJADV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577AbYEJADV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 20:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756485AbYEJADM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 20:03:12 -0400
Received: from www.tglx.de ([62.245.132.106]:50325 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499AbYEJADL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 20:03:11 -0400
Date: Sat, 10 May 2008 02:02:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: andreas.herrmann3@amd.com, mingo@elte.hu, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: enable hpet=force for AMD SB400
In-Reply-To: <20080509165501.a0fdb29d.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805100202140.3197@apollo.tec.linutronix.de>
References: <20080509094911.GG5023@alberich.amd.com> <20080509163731.5f851bec.akpm@linux-foundation.org> <alpine.LFD.1.10.0805100140490.3197@apollo.tec.linutronix.de> <20080509165501.a0fdb29d.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2008, Andrew Morton wrote:
> On Sat, 10 May 2008 01:42:30 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Fri, 9 May 2008, Andrew Morton wrote:
> > > On Fri, 9 May 2008 11:49:11 +0200
> > > Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> > > 
> > > > x86: enable hpet=force for ATI SB400
> > > 
> > > Sigh.
> > > 
> > > > Add quirk to allow forced usage of HPET on ATI SB400.
> > > > I stumbled over machines where HPET is enabled but not reported
> > > > by BIOS.
> > > 
> > > Is there no way in which we can probe for or identify this condition,
> > > rather than hoping that the user will find out about this boot option?
> > 
> > I'd love to have a sane solution for that, but looking at the rate of
> > HPET wreckage since we increased the usage of HPET I'm happy to have
> > this as an opt in thingy.
> > 
> 
> Well we don't have to auto-enable the hpet.  Simply adding a loud "you
> should try the hpet=force option" printk would help a lot of people.

Fair enough. I look into that.

Thanks,
	tglx
 
