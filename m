Return-Path: <linux-kernel-owner+w=401wt.eu-S1758479AbYEWPkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479AbYEWPkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbYEWPko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:40:44 -0400
Received: from gw.goop.org ([64.81.55.164]:51800 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500AbYEWPkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:40:43 -0400
Message-ID: <4836E55C.5000304@goop.org>
Date: Fri, 23 May 2008 16:40:12 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemcheck: SMP support
References: <20080523141759.GA1833@damson.getinternet.no>
In-Reply-To: <20080523141759.GA1833@damson.getinternet.no>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> This works on real hw, but not on qemu. It seems to get stuck waiting for one
> of the atomic values to change. Don't know why yet, it might just be yet
> another bug in qemu... (we've hit at least two of them so far. And they were
> real bugs too.)
>   

I've noticed that qemu mis-reports the eip of cmpxchg if it faults (it 
reports the eip of the start of the basic block, I think).  Does that 
match what you're seeing?

    J
