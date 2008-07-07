Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbYGGP4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbYGGP4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 11:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbYGGP4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 11:56:23 -0400
Received: from gw.goop.org ([64.81.55.164]:37690 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755264AbYGGP4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 11:56:23 -0400
Message-ID: <48723C9D.8090504@goop.org>
Date: Mon, 07 Jul 2008 08:56:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>, Petr Tesarik <ptesarik@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin
 with irqs disable
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com> <48630420.1090102@goop.org> <200807072150.39571.nickpiggin@yahoo.com.au> <200807072152.59823.nickpiggin@yahoo.com.au>
In-Reply-To: <200807072152.59823.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Although, you wouldn't need to oversubscribe physical CPUs to hit
> suboptimal behaviour.
>
> Basically, I just ask for performance improvement to be measured
> with some "realistic" configuration, then it should be easier to
> justify.

Overcommitting cpus system-wide is pretty common.  A use-case is 
consolidating a pile of underused non-performance-critical servers into 
one physical machine with a lot of VMs.  It doesn't take much load to 
cause a dhcp request to the dhcp server to steal a cpu away from the 
mysql server while it holds a lock...

I'll mail out my patches so we can have a more concrete discussion shortly.

    J
