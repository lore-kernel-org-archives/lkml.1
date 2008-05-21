Return-Path: <linux-kernel-owner+w=401wt.eu-S933278AbYEUJmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278AbYEUJmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 05:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbYEUJmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 05:42:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60142 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932654AbYEUJmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 05:42:13 -0400
Date: Wed, 21 May 2008 10:29:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       wim@iguana.be, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 18/57] iTCO: unlocked_ioctl, coding style and cleanup
Message-ID: <20080521102922.4f0c405d@core>
In-Reply-To: <200805211426.16234.rusty@rustcorp.com.au>
References: <20080519124659.31722.51847.stgit@core>
	<20080519130625.31722.68489.stgit@core>
	<20080520012658.274b0c1e.akpm@linux-foundation.org>
	<200805211426.16234.rusty@rustcorp.com.au>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've been pulling out s/down_trylock/down_nowait/ patches which effect others' 
> changes.  Those patches get moved to the end of my queue, and I'll revisit 
> them before an actual merge with Linus.

The watchdog drivers all got the semaphores removed in the patch set I
did so you can dump that bit.

> 
