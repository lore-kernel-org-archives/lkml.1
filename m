Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288AbYHLMQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbYHLMQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 08:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbYHLMQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 08:16:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33269 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752172AbYHLMQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 08:16:22 -0400
Date: Tue, 12 Aug 2008 12:58:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [patch 2/2] fastboot: use a DMI match table to set defaults for
 port-disable
Message-ID: <20080812125858.7543506d@lxorguk.ukuu.org.uk>
In-Reply-To: <20080812043718.038d3e56@infradead.org>
References: <20080811153542.61095e5c@infradead.org>
	<20080811153730.74599410@infradead.org>
	<1218503351.25524.28.camel@californication>
	<20080811220440.5cc1bc2d@infradead.org>
	<20080812091009.05a32b39@lxorguk.ukuu.org.uk>
	<20080812043718.038d3e56@infradead.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008 04:37:18 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> On Tue, 12 Aug 2008 09:10:09 +0100
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > > if you solder the board... well you can add a tiny kernel patch or
> > > change the dmi ;)
> > 
> > Lots of people have them modified and you can even buy them
> > pre-modded as an end user. It needs to be simpler than hacking your
> > kernel. In fact this argues that the port disables should be handled
> > by user space not by the kernel ?
> 
> which is a commandline option then; because once userspace runs you've
> already paid the price in terms of boottime otherwise and would make
> the idea entirely moot.

For the boot device yes, for the rest no. And the boot command line is
managed by the installer which is user space and vendor controlled so a
good place to put fuzzy complex logic like that.
