Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbYEWPtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbYEWPtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYEWPtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:49:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47315 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751414AbYEWPtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:49:08 -0400
Date: Fri, 23 May 2008 16:32:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       aoliva@redhat.com, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Haroldo Gamal <gamal@alternex.com.br>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 1/3] firmware: allow firmware files to be built into
 kernel image
Message-ID: <20080523163223.36423f7c@core>
In-Reply-To: <4836DBF3.1030307@ladisch.de>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	<4836DBF3.1030307@ladisch.de>
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

On Fri, 23 May 2008 17:00:03 +0200
Clemens Ladisch <clemens@ladisch.de> wrote:

> David Woodhouse wrote:
> > --- a/include/asm-generic/vmlinux.lds.h
> > +++ b/include/asm-generic/vmlinux.lds.h
> > +	/* Built-in firmware blobs */					\
> > +	.builtin_fw        : AT(ADDR(.builtin_fw) - LOAD_OFFSET) {	\
> > +		VMLINUX_SYMBOL(__start_builtin_fw) = .;			\
> > +		*(.builtin_fw)						\
> > +		VMLINUX_SYMBOL(__end_builtin_fw) = .;			\
> > +	}								\
> > +									\
> 
> Most drivers, when built as a module, would want their firmware images
> to be in the module and not in the kernel image.

When built as a module you must be using an initrd or have a file system
mounted so that case simply doesn't matter or arise.

Alan
