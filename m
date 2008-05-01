Return-Path: <linux-kernel-owner+w=401wt.eu-S1757531AbYEAJ2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbYEAJ2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 05:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755752AbYEAJ2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 05:28:07 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60822 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756250AbYEAJ2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 05:28:01 -0400
Date: Thu, 1 May 2008 10:19:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: mingo@redhat.com
Subject: Re: x86: 8K stacks by default
Message-ID: <20080501101956.695c5b34@core>
In-Reply-To: <200805010359.m413xWBV014593@hera.kernel.org>
References: <200805010359.m413xWBV014593@hera.kernel.org>
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

>     x86: 8K stacks by default
>     
>     Switch back to 8K stacks as the safer default. Out-of-memory
>     situations are less problematic than silent and hard to debug
>     stack corruption.

On its own that makes the problem worse not better. If you are going to
8K stacks fine but if you want them debuggable then 32bit needs to
always use separate IRQ stacks as well, otherwise you've merely made the
crash cases rarer and harder to debug (deep recursion colliding with deep
IRQ path)

Alan
