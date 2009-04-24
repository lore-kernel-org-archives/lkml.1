Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbZDXCNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbZDXCNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 22:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbZDXCNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 22:13:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55479 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbZDXCNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 22:13:14 -0400
Date: Thu, 23 Apr 2009 22:11:17 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
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
Message-ID: <20090424021117.GD28423@bombadil.infradead.org>
References: <20090423193206.GA14885@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423193206.GA14885@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 09:32:06PM +0200, Oleg Nesterov wrote:
> avr32, mn10300, parisc, s390, sh, xtensa:
> 
> they never set PT_DTRACE, but clear it after do_execve().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Kyle McMartin <kyle@mcmartin.ca>
