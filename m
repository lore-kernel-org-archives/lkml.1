Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbZDXAXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbZDXAXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 20:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZDXAXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 20:23:45 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:40450 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbZDXAXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 20:23:44 -0400
Date: Fri, 24 Apr 2009 09:18:34 +0900
From: Paul Mundt <lethal@linux-sh.org>
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
       Mike Frysinger <vapier.adi@gmail.com>,
       Roman Zippel <zippel@linux-m68k.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ptrace: remove PT_DTRACE from avr32, mn10300, parisc, s390, sh, xtensa
Message-ID: <20090424001834.GC27897@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roland McGrath <roland@redhat.com>, Chris Zankel <chris@zankel.net>,
	David Howells <dhowells@redhat.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Greg Ungerer <gerg@uclinux.org>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Helge Deller <deller@gmx.de>,
	Hirokazu Takata <takata@linux-m32r.org>,
	Jeff Dike <jdike@addtoit.com>, Kyle McMartin <kyle@mcmartin.ca>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Mike Frysinger <vapier.adi@gmail.com>,
	Roman Zippel <zippel@linux-m68k.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	linux-kernel@vger.kernel.org
References: <20090423193206.GA14885@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423193206.GA14885@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 09:32:06PM +0200, Oleg Nesterov wrote:
> avr32, mn10300, parisc, s390, sh, xtensa:
> 
> they never set PT_DTRACE, but clear it after do_execve().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
Acked-by: Paul Mundt <lethal@linux-sh.org>
