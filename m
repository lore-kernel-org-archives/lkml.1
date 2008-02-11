Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbYBKN5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbYBKN5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 08:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYBKN5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 08:57:09 -0500
Received: from aun.it.uu.se ([130.238.12.36]:35671 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbYBKN5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 08:57:08 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18352.21524.186194.426982@harpo.it.uu.se>
Date: Mon, 11 Feb 2008 14:56:36 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Adrian Bunk <adrian.bunk@movial.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Riku Voipio <riku.voipio@movial.fi>,
       Mikael Pettersson <mikpe@it.uu.se>,
       Lennert Buytenhek <buytenh@wantstofly.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: futex local DoS on most architectures
In-Reply-To: <20080211130700.GF27537@movial.fi>
References: <20080211130700.GF27537@movial.fi>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk writes:
 > The issue described in [1] is still present and unfixed (and even the 
 > fix there wasn't complete since it didn't cover SMP).
 > 
 > Thanks to Riku Voipio for noting that it is still unfixed.
 > 
 > cu
 > Adrian
 > 
 > [1] http://lkml.org/lkml/2007/8/1/474

I think calling it a local DoS may make people take it
less seriously.

The problem is not related to attacks or malice.
It's NORMAL futex usage on the affected architectures
that's broken and will throw the kernel into a loop.

/Mikael
