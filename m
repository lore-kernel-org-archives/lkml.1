Return-Path: <linux-kernel-owner+w=401wt.eu-S1758994AbYD3RJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994AbYD3RJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 13:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbYD3RJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 13:09:24 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38789 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755132AbYD3RJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 13:09:24 -0400
Date: Wed, 30 Apr 2008 18:01:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: John Clark <jclark@metricsystems.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem with 8250_pnp Module and using ttyS0 as console
Message-ID: <20080430180133.1e1f940b@core>
In-Reply-To: <48189FE7.9040208@metricsystems.com>
References: <48189FE7.9040208@metricsystems.com>
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

On Wed, 30 Apr 2008 09:35:51 -0700
John Clark <jclark@metricsystems.com> wrote:

> Linux version... at least as far back as 2.6.19 and upto and including 
> the latest
> one I've tested, 2.6.25.
> 
> 
> When the kernel has been configured to use ttyS0 as the console port, via
> modification of the boot command line, 'console=ttyS0,115200', the kernel
> ultimately traps with an exception, if the module "8250_pnp.ko" is loaded.
> 
> Removing this module eliminates the fault.
> 
> Is this a problem or a documented incompatibility?

Hard to tell without the trace. Can you capture the trace and let me
know. It's not supposed to give you an exception but we need to see the
exception to change that.

