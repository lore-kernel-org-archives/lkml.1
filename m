Return-Path: <linux-kernel-owner+w=401wt.eu-S1763339AbZE0MuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763339AbZE0MuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 08:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762492AbZE0MuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 08:50:06 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:38486 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759634AbZE0MuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 08:50:06 -0400
Date: Wed, 27 May 2009 14:47:36 +0200
From: Harald Welte <HaraldWelte@viatech.com>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [VIA Support] was: [BUG FIX] Make x86_32 uni-processor Atomic
	ops, Atomic
Message-ID: <20090527124736.GU4024@prithivi.gnumonks.org>
References: <200905221139.26941.lkml@morethan.org> <4A188A48.5000208@zytor.com> <20090524064905.GH20452@prithivi.gnumonks.org> <200905270718.11093.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905270718.11093.lkml@morethan.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 07:18:08AM -0500, Michael S. Zick wrote:
> On Sun May 24 2009, Harald Welte wrote:
> > 
> > Once I understand it in full detail, I can talk to the right people inside
> > CentaurLabs (VIA's CPU division).  
> > 
> > If somebody (optionally) can phrase a precise technical question that I can
> > directly forward to somebody with low-level x86 knowledge but no Linux background,
> > it would definitely help speeding up the process.
> > 
> 
> What is the PCI Cache Line size in the CX700?  In the CN896?

The chipset documentation doesn't say anything about that, I'd have to inquire
inside VIA.  I doubt any difference between CX700/CN896.

Also, setting the PCI config space register to a too small cache line size
(such as 32) on a system that supports more (say 64) doesn't really cause any
problems, but just reduces performance - as far as I know.

Setting it too big will cause trouble.  But since 32 is the default and
only on AMD and Intel CPU's it is increased, I see no issue here either.

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
