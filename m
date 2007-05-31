Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbXEaCep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbXEaCep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 22:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbXEaCei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 22:34:38 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746AbXEaCeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 22:34:37 -0400
Date: Wed, 30 May 2007 19:33:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Tero Roponen <teanropo@jyu.fi>,
       Antonino Daplas <adaplas@gmail.com>
Subject: Re: [3/4] 2.6.22-rc3: known regressions
In-Reply-To: <465C222A.8060003@googlemail.com>
Message-ID: <alpine.LFD.0.98.0705301922560.26602@woody.linux-foundation.org>
References: <465C188F.9000900@googlemail.com>
 <465C222A.8060003@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-ID: <alpine.LFD.0.98.0705301923271.26602@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 May 2007, Michal Piotrowski wrote:
> 
> Subject    : hrtimer overflow bug on 64-bit systems
> References : http://lkml.org/lkml/2007/5/24/391
> Submitter  : David Miller <davem@davemloft.net>
> Status     : problem is being debugged

Should be fixed by commit eaad084bb.

> TTY
> 
> Subject    : tty-related oops in latest kernel(s)
> References : http://lkml.org/lkml/2007/5/27/104
> Submitter  : Tero Roponen <teanropo@jyu.fi>
> Status     : problem is being debugged

People seem to have debugged this to neofb palette handling, but I haven't 
seen a patch. Antonino?

		Linus
