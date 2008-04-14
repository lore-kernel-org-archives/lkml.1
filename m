Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbYDNKbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbYDNKbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 06:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbYDNKb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 06:31:28 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:16122 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbYDNKb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:31:27 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Tilman Schmidt <tilman@imap.cc>,
       Valdis.Kletnieks@vt.edu, Mark Lord <lkml@rtr.ca>,
       David Miller <davem@davemloft.net>, jesper.juhl@gmail.com,
       yoshfuji@linux-ipv6.org, jeff@garzik.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Reporting bugs and bisection
From: Andi Kleen <andi@firstfloor.org>
References: <47FEADCB.7070104@rtr.ca>
	<22880.1207943922@turing-police.cc.vt.edu> <47FFE5DA.8000709@imap.cc>
	<200804132040.12138.rjw@sisk.pl> <20080413184730.GD8474@1wt.eu>
	<20080413121831.d89dd424.akpm@linux-foundation.org>
	<20080414101813.GB14549@elte.hu>
Date: Mon, 14 Apr 2008 12:29:26 +0200
In-Reply-To: <20080414101813.GB14549@elte.hu> (Ingo Molnar's message of "Mon, 14 Apr 2008 12:18:13 +0200")
Message-ID: <87ve2kviex.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Apr 2008 10:22:41.0397 (UTC) FILETIME=[788D8250:01C89E19]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
>
> doing _kernel_ bisection is totally hard at the moment - it disrupts the 
> user way too much and causes many hours of work for most users. 

It depends. Sometimes the bisection can be done in qemu/kvm/xen or
similar tools.  At least if the problem is not too hardware
dependent. And more and more people actually run in such environments.

I can also do it faster with autoboot or nfs root/powerswitch, but 
admittedly that's a very specialized setup most people don't have.

Still I agree with your basic point that it should be only
last resort.

-Andi
