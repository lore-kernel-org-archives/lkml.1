Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbYJFO6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbYJFO6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 10:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbYJFO5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 10:57:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:33166 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbYJFO5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 10:57:51 -0400
Date: Mon, 6 Oct 2008 07:57:38 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: RFC: banning device driver reserved resources from /dev/mem
Message-ID: <20081006075738.318a983f@infradead.org>
In-Reply-To: <20081006153825.66e50770@lxorguk.ukuu.org.uk>
References: <20081005180154.7cc12486@infradead.org>
	<20081006102739.16d1a434@lxorguk.ukuu.org.uk>
	<48EA1540.8060409@gmail.com>
	<20081006144835.6e58f73a@lxorguk.ukuu.org.uk>
	<20081006065213.76dc729a@infradead.org>
	<20081006150122.3860cae1@lxorguk.ukuu.org.uk>
	<20081006070543.23b14828@infradead.org>
	<20081006151411.05ed5f50@lxorguk.ukuu.org.uk>
	<20081006072437.5d1360dd@infradead.org>
	<20081006153825.66e50770@lxorguk.ukuu.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> For debug tools that would be almost all drivers, and for distribution
> use that needs to be a runtime selection.

is boottime (read: kernel parameter) ok ?
it would totally make sense to have a kernel boot parameter that
disables all /dev/mem sanity checks.

> 
> For the non share-resource-with case what occurs if /dev/mem is active
> when the driver is loaded ?

that's a hard case but probably not the most interesting case; drivers
get loaded early thankfully.
(yes revoke is hard ;( )



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
