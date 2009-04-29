Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbZD2T6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbZD2T6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbZD2T6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:58:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39595 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbZD2T6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:58:45 -0400
Date: Wed, 29 Apr 2009 15:53:37 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, chris@zankel.net, cooloney@kernel.org,
       deller@gmx.de, geert@linux-m68k.org, gerg@uclinux.org,
       hskinnemoen@atmel.com, jdike@addtoit.com, jesper.nilsson@axis.com,
       kyle@mcmartin.ca, linux@arm.linux.org.uk, ralf@linux-mips.org,
       rth@twiddle.net, starvik@axis.com, takata@linux-m32r.org,
       ysato@users.sourceforge.jp, zippel@linux-m68k.org,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: Fwd: arch/ && tracehook_report_syscall_xxx()
Message-ID: <20090429195337.GF5264@bombadil.infradead.org>
References: <20090427180455.GA32509@redhat.com> <20090427182919.B923DFC3BF@magilla.sf.frob.com> <20090427183218.GA31596@lst.de> <20090429190852.GA14515@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429190852.GA14515@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 09:08:52PM +0200, Oleg Nesterov wrote:
> So. Dear maintainers of
> 
> 	parisc
> 
> . Could you please convert your syscall trace code to use
> tracehook_report_syscall_entry/tracehook_report_syscall_exit ?
> 

I've got this mostly completed and working on parisc (at least, gdb
and strace continue working, so I'm happy with that result... :)

I'll probably push it for .30 since it seems harmless.

--Kyle
