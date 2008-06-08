Return-Path: <linux-kernel-owner+w=401wt.eu-S1763673AbYFHLNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763673AbYFHLNy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 07:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757617AbYFHLNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 07:13:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55730 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542AbYFHLNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 07:13:44 -0400
Date: Sun, 8 Jun 2008 08:13:29 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       David Miller <davem@davemloft.net>,
       James.Bottomley@HansenPartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the
 kernel.
Message-ID: <20080608081329.36dce5e1@gaivota>
In-Reply-To: <1212102258.20303.6.camel@shinybook.infradead.org>
References: <1212077700.26088.83.camel@shinybook.infradead.org>
	<20080529164745.GA21763@kroah.com>
	<483F1232.4010003@linux.intel.com>
	<20080529.140919.160813310.davem@davemloft.net>
	<483F1C17.8040207@linux.intel.com>
	<1212102258.20303.6.camel@shinybook.infradead.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008 02:04:18 +0300
David Woodhouse <dwmw2@infradead.org> wrote:

> The firmware is an independent and separate work in itself. Section 2 of
> the GPL talks about such sections of the work, explicitly.

For me, both inside kernel or on a separate tree would produce similar results.
Yet, a separate tree will be a little more painful.

One alternative to keep this at kernel -git tree would be to write a COPYING or
LICENSE file at firmware dir, explicitly stating that most of those firmwares
have proprietary licenses and are there just to make easier for kernel develoment.

Being in-tree or out kernel tree, we should explicitly state what license each
firmware uses, and having the license terms of proprietary firmwares there.

I would add a metatag at the .ihex file to reference to what license applies to
each firmware. Something like FIRMWARE_LICENSE("some vendor license #1"). For
those legacy firmwares where we don't know, we may simply add "unknown".

Cheers,
Mauro
