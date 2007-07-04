Return-Path: <linux-kernel-owner+w=401wt.eu-S1760764AbXGDMLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760764AbXGDMLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 08:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbXGDMLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 08:11:35 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47146 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754849AbXGDMLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 08:11:34 -0400
Date: Wed, 4 Jul 2007 13:17:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: Libata PATA status
Message-ID: <20070704131746.4bbe4d0e@the-village.bc.nu>
In-Reply-To: <p73k5tg2uj9.fsf@bingen.suse.de>
References: <20070703185116.59c8f5f5@the-village.bc.nu>
	<p73k5tg2uj9.fsf@bingen.suse.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04 Jul 2007 15:00:26 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> > 
> > Post SRST 
> What is SRST?
> 
> My personal wish list feature would be a little forwarder driver
> to forward /dev/hd* to /dev/sd* for this; then old IDE could be
> disabled without risking breaking old root file systems.

That would be udevd for new systems or "ln -s" for old ones ? 

I don't see a way to build that "simple" forwarder because the device
allocation is now dynamic rather than tied to specific device on specific
port - a concept with really no meaning any more.

Alan
