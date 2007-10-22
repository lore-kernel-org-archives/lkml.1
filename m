Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbXJVJnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbXJVJnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 05:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbXJVJnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 05:43:05 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34919 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751526AbXJVJnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 05:43:02 -0400
Date: Mon, 22 Oct 2007 10:46:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Federico Sevilla III <jijo@fs3.ph>
Cc: linux-kernel@vger.kernel.org
Subject: Re: "spurious completions during NCQ" with 2.6.23.1 and DVD
 Multi-Recorder on Thinkpad T61
Message-ID: <20071022104619.0a554cea@the-village.bc.nu>
In-Reply-To: <1193018170.4672.20.camel@humanitas.fs3.ph>
References: <1193018170.4672.20.camel@humanitas.fs3.ph>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007 09:56:10 +0800
Federico Sevilla III <jijo@fs3.ph> wrote:

> Hi,
> 
> Using the 2.6.23.1 kernel and Debian Etch on a Lenovo Thinkpad T61
> 7659A21, I am getting two weird errors, as follows:

Turn off bluetooth and you may find the stuck IRQ goes away - at least on
some thinkpads there are weird extra IRQs when bluetooth is running which
break stuff.

Alan
