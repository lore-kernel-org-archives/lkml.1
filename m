Return-Path: <linux-kernel-owner+w=401wt.eu-S1764242AbYD3Tk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764242AbYD3Tk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 15:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758763AbYD3Tkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 15:40:49 -0400
Received: from smtp.ono.com ([62.42.230.12]:25127 "EHLO resmaa05.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757997AbYD3Tks convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 15:40:48 -0400
Date: Wed, 30 Apr 2008 21:40:45 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Problems with -git14
Message-ID: <20080430214045.78c307d9@werewolf.home>
In-Reply-To: <Pine.LNX.4.64.0804301516580.30549@blonde.site>
References: <20080430015655.5a42f63d@werewolf.home>
	<Pine.LNX.4.64.0804301516580.30549@blonde.site>
X-Mailer: Claws Mail 3.4.0cvs16 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 16:17:46 +0100 (BST), Hugh Dickins <hugh@veritas.com> wrote:

> On Wed, 30 Apr 2008, J.A. Magallón wrote:
> > 
> > I have a couple problems with latest git (-14):
> > 
> > - It only recognises 2 processors out of 4 (dual Xeon HT)
 
> [PATCH] x86_32: fix HT cpu booting
> 
> Since recent smpboot 32/64-bit merge, my dual Xeon with HT has been
> booting only 2 of its 4 cpus (when running an i386 kernel; but x86_64
> is okay).  J.A. Magallón reports the same.
> 
> native_cpu_up: bad cpu 2
> native_cpu_up: bad cpu 3
> 
> The mach-default cpu_present_to_apicid() was just returning cpu number
> (2, 3) instead of apicid (6, 7): looks like we now need the x86_64 code
> even for the i386 case.
> 

One question that always bugs me: do I have to set NR_CPUS=8 to pick
apicid number 7, and let the map just flag the ones I have, or will
it work with NR_CPUS=4 ?

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam05 (gcc 4.2.2 20071128 (4.2.2-2mdv2008.1)) SMP PREEMPT
