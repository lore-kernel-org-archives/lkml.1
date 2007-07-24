Return-Path: <linux-kernel-owner+w=401wt.eu-S1763798AbXGXTOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763798AbXGXTOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 15:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755392AbXGXTOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 15:14:19 -0400
Received: from gw.goop.org ([64.81.55.164]:51316 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946AbXGXTOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 15:14:17 -0400
Message-ID: <46A64F4F.80107@goop.org>
Date: Tue, 24 Jul 2007 12:13:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH][RFC] getting rid of stupid loop in BUG()
References: <20070724153916.GS21668@ftp.linux.org.uk> <46A62F35.2000501@goop.org> <20070724171455.GT21668@ftp.linux.org.uk>
In-Reply-To: <20070724171455.GT21668@ftp.linux.org.uk>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> Works here...
>   

Hm, doesn't here:

  CC      arch/i386/kernel/irq.o
/home/jeremy/hg/xen/paravirt/linux/arch/i386/kernel/irq.c: In function '__BUG':
include2/asm/bug.h:29: warning: 'noreturn' function does return

This is with current FC7 distro gcc: gcc version 4.1.2 20070502 (Red Hat
4.1.2-12)

    J
