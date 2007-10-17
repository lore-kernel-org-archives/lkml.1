Return-Path: <linux-kernel-owner+w=401wt.eu-S935971AbXJQCaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935971AbXJQCaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 22:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758607AbXJQC35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 22:29:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37192 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754103AbXJQC34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 22:29:56 -0400
Date: Tue, 16 Oct 2007 19:23:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dipankar Sarma <dipankar@in.ibm.com>
cc: Gautham R Shenoy <ego@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Rusty Russel <rusty@rustcorp.com.au>, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@us.ibm.com>
Subject: Re: [RFC PATCH 0/4] Refcount Based Cpu-Hotplug Revisit.
In-Reply-To: <20071017021112.GA15895@in.ibm.com>
Message-ID: <alpine.LFD.0.999.0710161922430.26902@woody.linux-foundation.org>
References: <20071016103308.GA9907@in.ibm.com>
 <alpine.LFD.0.999.0710161015510.6887@woody.linux-foundation.org>
 <20071017021112.GA15895@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2007, Dipankar Sarma wrote:
> 
> Unless I am reading the patch wrongly, it seems cpu_hotplug_begin() is called 
> while holding the cpu_add_remove_lock mutex. So, another CPU cannot come in
> and do the same until _cpu_down() is over.

Ahh, in that case I take back that objection, although maybe a comment 
about the required nesting within the other mutex is in order? Or maybe 
it's there and I just missed it (blush).

			Linus
