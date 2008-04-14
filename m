Return-Path: <linux-kernel-owner+w=401wt.eu-S1762810AbYDNRBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762810AbYDNRBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760464AbYDNRBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:01:10 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34610 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755730AbYDNRBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:01:09 -0400
Date: Mon, 14 Apr 2008 17:56:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
Cc: htejun@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Again... DMA speed too slow
Message-ID: <20080414175636.4ea815dc@core>
In-Reply-To: <48038c3e.P3RWjRNXsDrhjIX7%Joerg.Schilling@fokus.fraunhofer.de>
References: <48038c3e.P3RWjRNXsDrhjIX7%Joerg.Schilling@fokus.fraunhofer.de>
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

On Mon, 14 Apr 2008 18:54:22 +0200
Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling) wrote:

> >Which controller are you on?  I bet the recording itself will work fine
> >on 48x.  It's probably that READ/WRITE BUFFERs are executed using PIO
> >for compatibility reasons. 
> 
> If this happens inside Linux, Linux should be changed...

The cases Linux falls back to PIO are the cases where the hardware isn't
up to it, or reliably handling some DMA commands. Lots of that about in
the PC world.

> 2.01.01a38 is the latest. Install cdrecord suid root

Remarkably brave ;)
