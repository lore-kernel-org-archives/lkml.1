Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbYGUAbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbYGUAbD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:31:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbYGUAax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:30:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:56809 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbYGUAaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:30:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wtpwvVp+jRBopjOCci0g0FGGGtWbDD8scdEAEYlBFPWHra4qeWj1RqsSRQ7yUyw5cW
         q5Agi15Ltp80atCun0eVLUmdXXDw60j5o1qnR8aaCFn1uo3nICDrwKrt0ezCtqYt042W
         JFnQZOWVSKcXU78LSDqIGcxl9A7XVRejC5+hE=
Date: Mon, 21 Jul 2008 04:28:37 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>, rth@twiddle.net,
       rmk@arm.linux.org.uk, hskinnemoen@atmel.com, cooloney@kernel.org,
       starvik@axis.com, dhowells@redhat.com, ysato@users.sourceforge.jp,
       tony.luck@intel.com, takata@linux-m32r.org, geert@linux-m68k.org,
       ralf@linux-mips.org, matthew@wil.cx, schwidefsky@de.ibm.com,
       lethal@linux-sh.org, chris@zankel.net
Subject: Re: [PATCH 0/22] Introducing asm/syscalls.h
Message-ID: <20080721002837.GA3851@martell.zuzino.mipt.ru>
References: <1216592500.3679.14.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216592500.3679.14.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 03:51:40AM +0530, Jaswinder Singh wrote:
> The following series of patches introduce asm/syscalls.h in various
> architectures.

Copyright for a bunch of prototypes?

All those /* kernel/signal.c */ comments are generally stupid and
useless, so no point adding even for functions that rarely move
(syscalls).

Of course, there is no explanation why files are being added.

