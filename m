Return-Path: <linux-kernel-owner+w=401wt.eu-S1753083AbZDXIRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbZDXIRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 04:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbZDXIRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 04:17:07 -0400
Received: from relay.atmel.no ([80.232.32.139]:56391 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbZDXIRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 04:17:06 -0400
Date: Fri, 24 Apr 2009 10:13:35 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Chris Zankel <chris@zankel.net>,
       David Howells <dhowells@redhat.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Helge Deller <deller@gmx.de>, Hirokazu Takata <takata@linux-m32r.org>,
       Jeff Dike <jdike@addtoit.com>, Kyle McMartin <kyle@mcmartin.ca>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ptrace: remove PT_DTRACE from avr32, mn10300,
 parisc, s390, sh, xtensa
Message-ID: <20090424101335.214f6572@hskinnemoen-d830>
In-Reply-To: <20090423193206.GA14885@redhat.com>
References: <20090423193206.GA14885@redhat.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> avr32, mn10300, parisc, s390, sh, xtensa:
> 
> they never set PT_DTRACE, but clear it after do_execve().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
