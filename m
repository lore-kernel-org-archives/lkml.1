Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYGOWNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYGOWNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754481AbYGOWNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:13:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42086 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbYGOWNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:13:11 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, david@lang.hm,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <487D1925.50008@garzik.org>
References: <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org>
	 <487C585C.2060002@garzik.org>
	 <alpine.LFD.1.10.0807150803580.3017@woody.linux-foundation.org>
	 <487CD7FE.9010209@garzik.org>
	 <alpine.LFD.1.10.0807151008450.3017@woody.linux-foundation.org>
	 <487CDEC0.3090004@garzik.org>
	 <alpine.LFD.1.10.0807151041080.3017@woody.linux-foundation.org>
	 <487CEA73.9000408@garzik.org>
	 <alpine.LFD.1.10.0807151124510.3017@woody.linux-foundation.org>
	 <487CF01E.6000208@garzik.org> <20080715185801.GH8185@mit.edu>
	 <487CF70C.1030309@garzik.org>
	 <alpine.LFD.1.10.0807151218460.3351@woody.linux-foundation.org>
	 <487D1327.7090805@garzik.org>
	 <alpine.LFD.1.10.0807151420550.2867@woody.linux-foundation.org>
	 <487D1925.50008@garzik.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 15:12:39 -0700
Message-Id: <1216159959.26991.48.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 17:39 -0400, Jeff Garzik wrote:
> 
> 'make modules_install && make install' will
>         * install modules in /lib
>         * install firmware in /lib      [2.6.27 only]
>         * install kernel
>         * update grub
>         * rebuild initrd
> 
> Do this, under both 2.6.26 and 2.6.27.
> 
> 2.6.26 will put a working driver into initrd.
> 
> 2.6.27 will put a dead driver into initrd (because no firmware got 
> copied into initrd image).

I believe your claim is untrue. It uses the distribution's tool to
create the initrd, doesn't it? And those tools _do_ handle the
MODULE_FIRMWARE() tags and pull in appropriate firmware. They've had to
get that right for _years_ already.

-- 
dwmw2

