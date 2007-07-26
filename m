Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbXGZKKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbXGZKKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 06:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbXGZKKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 06:10:07 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46089 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755889AbXGZKKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 06:10:05 -0400
Date: Thu, 26 Jul 2007 11:16:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Masoud Sharbiani" <masouds@google.com>,
       "Kirill Korotaev" <dev@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: i386-show-unhandled-signals-v3
Message-ID: <20070726111652.56467031@the-village.bc.nu>
In-Reply-To: <200707261146.23886.ak@suse.de>
References: <20070718154759.GA26425@google.com>
	<4517d1380707251407v178068baxcc76a86f8337cc27@mail.gmail.com>
	<20070725162528.7d485ff8.akpm@linux-foundation.org>
	<200707261146.23886.ak@suse.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007 11:46:23 +0200
Andi Kleen <ak@suse.de> wrote:

> 
> > Look: if there's a way in which an unprivileged user can trigger a printk
> > we fix it, end of story. 
> 
> I'm firmly against disabling it on x86-64 by default. The printks are extremly
> useful and have found many bugs in the past.

Then add the rate limiting by default.

Lots of things are convenient. Being able to read arbitary kernel memory
from user space is frequently convenient for debugging but that doesn't
mean its a good idea or should be allowed
