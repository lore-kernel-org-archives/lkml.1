Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbYKDQVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbYKDQVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbYKDQVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:21:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:47678 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbYKDQU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:20:59 -0500
Date: Tue, 4 Nov 2008 08:21:35 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, USB list <linux-usb@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc3: usb_hcd_poll_rh_status: array subscript is above
 array bounds
Message-ID: <20081104082135.07597ce0@infradead.org>
In-Reply-To: <Pine.LNX.4.44L0.0811041108430.3614-100000@iolanthe.rowland.org>
References: <200811041901.55808.arvidjaar@mail.ru>
	<Pine.LNX.4.44L0.0811041108430.3614-100000@iolanthe.rowland.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008 11:10:33 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> > Dp you know if it was ever reported to gcc folks?
> 
> I have no idea.  All I know is what was reported on LKML.

I reported this bug (well from a different part of the kernel, but same
warning) to gcc and yes it's a "gcc behavior"
apparently they produce the warning in a phase of the compiler before
the optimization to remove this code as "not taken".

There's a fix floating around but it's only a partial fix or something
like that.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
