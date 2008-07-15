Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbYGOVZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbYGOVZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762986AbYGOVZC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:25:02 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40378 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762964AbYGOVZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:25:00 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, david@lang.hm,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <487D1327.7090805@garzik.org>
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
Content-Type: text/plain
Date: Tue, 15 Jul 2008 14:24:21 -0700
Message-Id: <1216157061.26991.41.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 17:14 -0400, Jeff Garzik wrote:
> Linus Torvalds wrote:
> > 
> > On Tue, 15 Jul 2008, Jeff Garzik wrote:
> >> Already started, in fact, since Linus said he would not reject it out of
> >> hands.
> > 
> > Btw, I need to see it actually solve a real problem. As it is, I really 
> > think you've just painted yourself into a corner where you can't just 
> > admit that we can just load the firmware directly.
> 
> Kernel 2.6.26.  Older userland w/ initrd requirement, plus module w/ 
> compiled-in firmware.
> 
> Simply dropping 2.6.27 into that situation will produce an unbootable 
> system, since the firmware would not get copied into the initrd.

Kernel 2.6.15 with ancient userland. You update to 2.6.16, which
includes commit 5433383e ('convert qla2xxx to request_firmware()').

Same problem? Only three years ago. And not really a problem back then
either, because _even_ then you had to have a fairly ancient userland
for it not to work.

You're far too late to start whining about it now, Jeff. We're just
cleaning up the last drivers now. The rest have been where we want them
to be for _years_.

-- 
dwmw2

