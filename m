Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbZDXHex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbZDXHex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 03:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZDXHeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 03:34:44 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:46192 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbZDXHeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 03:34:44 -0400
Date: Fri, 24 Apr 2009 09:34:01 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Chris Zankel <chris@zankel.net>,
       David Howells <dhowells@redhat.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Helge Deller <deller@gmx.de>, Hirokazu Takata <takata@linux-m32r.org>,
       Jeff Dike <jdike@addtoit.com>, Kyle McMartin <kyle@mcmartin.ca>,
       Mike Frysinger <vapier.adi@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ptrace: remove PT_DTRACE from avr32, mn10300,
 parisc, s390, sh, xtensa
Message-ID: <20090424093401.1dd8086b@skybase>
In-Reply-To: <20090423193206.GA14885@redhat.com>
References: <20090423193206.GA14885@redhat.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009 21:32:06 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> avr32, mn10300, parisc, s390, sh, xtensa:
> 
> they never set PT_DTRACE, but clear it after do_execve().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

