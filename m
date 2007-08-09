Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbXHIR5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbXHIR5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755134AbXHIR4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:56:34 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48401 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758101AbXHIR4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:56:33 -0400
Date: Thu, 9 Aug 2007 19:03:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 23/25] [PATCH] paravirt hooks for arch initialization
Message-ID: <20070809190303.214e5457@the-village.bc.nu>
In-Reply-To: <46BB5258.8040609@goop.org>
References: <11865467522495-git-send-email-gcosta@redhat.com>
	<11865468394005-git-send-email-gcosta@redhat.com>
	<11865468431616-git-send-email-gcosta@redhat.com>
	<200708081144.04119.ak@suse.de>
	<46BB5258.8040609@goop.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> What's the EBDA actually used for?  The only place which seems to use
> ebda_addr is in the e820 code to avoid that area as RAM.

It belongs to the firmware. 
