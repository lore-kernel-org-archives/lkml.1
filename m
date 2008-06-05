Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbYFENLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbYFENLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 09:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbYFENLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 09:11:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37125 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753181AbYFENLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 09:11:04 -0400
Date: Thu, 5 Jun 2008 13:54:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hugh Dickins <hugh@veritas.com>
Cc: Olaf Hering <olaf@aepfle.de>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc5 (G5 SATA broken)
Message-ID: <20080605135444.7a1e5158@core>
In-Reply-To: <Pine.LNX.4.64.0806051255340.28792@blonde.site>
References: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org>
	<20080605112436.GA4533@aepfle.de>
	<Pine.LNX.4.64.0806051255340.28792@blonde.site>
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

> And the patch I'm finding successful is below: I won't sign it off,
> for all I know it's reverting part of what Alan is trying to achieve;
> but I expect it'll help towards the right fix.

Its the right fix 

	ata_sff_check_altstatus() is a routine which does the altstatus
check and may or may not call the helper

	ata_sff_check_status() is a default method for ap->ops->

This lunatic naming leads to mistakes 8(
