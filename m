Return-Path: <linux-kernel-owner+w=401wt.eu-S934210AbXEWN4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934210AbXEWN4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 09:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765020AbXEWN4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 09:56:17 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60826 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765875AbXEWN4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 09:56:15 -0400
Date: Wed, 23 May 2007 15:01:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Micah Cowan <micah@cowan.name>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] Only send SIGXFSZ when exceeding rlimits.
Message-ID: <20070523150100.64b72655@the-village.bc.nu>
In-Reply-To: <20070523131305.37DA53C98102@mabruk.micah.cowan.name>
References: <20070523131305.37DA53C98102@mabruk.micah.cowan.name>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2007 17:19:35 -0700
Micah Cowan <micah@cowan.name> wrote:

> Some users have been having problems with utilities like cp or dd
> dumping core when they try to copy a file that's too large for the
> destination filesystem (typically, > 4gb). Apparently, some defunct
> standards required SIGXFSZ to be sent in such circumstances, but SUS
> only requires/allows it for when a written file exceeds the process's
> resource limits. I'd like to limit SIGXFSZs to the bare minimum required
> by SUS.
> 
> Patch sent per http://lkml.org/lkml/2007/4/10/302
> 
> Signed-off-by: Micah Cowan <micahcowan@ubuntu.com>

Acked-by: Alan Cox <alan@redhat.com>

