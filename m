Return-Path: <linux-kernel-owner+w=401wt.eu-S1762786AbZE0NBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762786AbZE0NBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 09:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758137AbZE0NA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 09:00:56 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:33066 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758100AbZE0NA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 09:00:56 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [VIA Support] was: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Wed, 27 May 2009 08:00:53 -0500
User-Agent: KMail/1.9.9
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200905221139.26941.lkml@morethan.org> <200905270718.11093.lkml@morethan.org> <20090527124736.GU4024@prithivi.gnumonks.org>
In-Reply-To: <20090527124736.GU4024@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905270800.55509.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed May 27 2009, Harald Welte wrote:
> On Wed, May 27, 2009 at 07:18:08AM -0500, Michael S. Zick wrote:
> > On Sun May 24 2009, Harald Welte wrote:
> > > 
> > > Once I understand it in full detail, I can talk to the right people inside
> > > CentaurLabs (VIA's CPU division).  
> > > 
> > > If somebody (optionally) can phrase a precise technical question that I can
> > > directly forward to somebody with low-level x86 knowledge but no Linux background,
> > > it would definitely help speeding up the process.
> > > 
> > 
> > What is the PCI Cache Line size in the CX700?  In the CN896?
> 
> The chipset documentation doesn't say anything about that, I'd have to inquire
> inside VIA.  I doubt any difference between CX700/CN896.
> 
> Also, setting the PCI config space register to a too small cache line size
> (such as 32) on a system that supports more (say 64) doesn't really cause any
> problems, but just reduces performance - as far as I know.
> 
> Setting it too big will cause trouble.  But since 32 is the default and
> only on AMD and Intel CPU's it is increased, I see no issue here either.
> 

Since the system chip sets where designed for use with the processor -
I am going to poke it up to the processor cache line size - just for fun.

If our assumptions are correct (I do agree with your statements myself) -
then all that will happen is we halve the number of cache line flushes. ;)
If not, perhaps we get another test case data point to consider.

Thanks for the quick reply;
Mike

