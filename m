Return-Path: <linux-kernel-owner+w=401wt.eu-S965400AbXBLVAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965400AbXBLVAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 16:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965403AbXBLVAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 16:00:35 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:40525 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965400AbXBLVAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 16:00:34 -0500
Subject: Re: NAK new drivers without proper power management?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.62.0702121653160.2928@pademelon.sonytel.be>
References: <1171058269.1484.64.camel@nigel.suspend2.net>
	 <1171059433.8675.195.camel@laptopd505.fenrus.org>
	 <20070210193851.GA3956@ucw.cz> <200702102320.39531.rjw@sisk.pl>
	 <Pine.LNX.4.62.0702120948230.10436@chinchilla.sonytel.be>
	 <20070212150410.GA17400@elf.ucw.cz>
	 <Pine.LNX.4.62.0702121653160.2928@pademelon.sonytel.be>
Content-Type: text/plain
Date: Tue, 13 Feb 2007 07:38:08 +1100
Message-Id: <1171312688.4081.9.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2007-02-12 at 16:57 +0100, Geert Uytterhoeven wrote:
> On Mon, 12 Feb 2007, Pavel Machek wrote:
> > > Can't the upper layer just assume -ENOSYS if .resume/.suspend is NULL?
> > > It's nicer if you don't have to implement dummy functions at all.
> > 
> > Unfortunately, drivers currently assume "NULL == nothing is needed",
> > so we'd have t do big search & replace... 
> 
> Which means you also cannot easily keep track of which driver supports
> suspend/resume and which doesn't, as there will always be drivers where a
> missing suspend/resume function is correct.
> 
> Wouldn't it be more sensible to have
> 
>     .suspend = suspend_nothing_to_do
> 
> instead, and reserve NULL for `not yet implemented'?

Agreed.

Regards,

Nigel

