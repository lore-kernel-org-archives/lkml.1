Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbXHRFVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbXHRFVj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 01:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbXHRFVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 01:21:21 -0400
Received: from 1wt.eu ([62.212.114.60]:1727 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbXHRFVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 01:21:20 -0400
Date: Sat, 18 Aug 2007 07:13:50 +0200
From: Willy Tarreau <w@1wt.eu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Authenticated <NWQ3MzhlY2QwZDAzODVhN@steudten.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel 2.6.20:  INFO: possible circular locking dependency detected
Message-ID: <20070818051349.GM6002@1wt.eu>
References: <46C48E73.8090309@steudten.com> <20070816212348.0d260d06@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070816212348.0d260d06@the-village.bc.nu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 09:23:48PM +0100, Alan Cox wrote:
> On Thu, 16 Aug 2007 19:50:43 +0200
> Authenticated <NWQ3MzhlY2QwZDAzODVhN@steudten.com> wrote:
> 
> > 
> > =======================================================
> > [ INFO: possible circular locking dependency detected ]
> > 2.6.20-1.2948.self #1
> > -------------------------------------------------------
> > squid/4058 is trying to acquire lock:
> >  (tty_mutex){--..}, at: [<c019fb54>] print_warning+0x8b/0x12e
> > 
> > but task is already holding lock:
> >  (&s->s_dquot.dqptr_sem){----}, at: [<c01a0802>] dquot_alloc_inode+0x34/0x10a
> > 
> > which lock already depends on the new lock.
> 
> Yep - known 2.6.20 problem. Its very very unlikely to ever cause a real
> problem however.

Is there any known unmerged fix for this one ?

Willy

