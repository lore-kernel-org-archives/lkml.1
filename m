Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbYHLOCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbYHLOCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbYHLOCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:02:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:38232 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbYHLOCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:02:13 -0400
Date: Tue, 12 Aug 2008 07:02:22 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [patch 1/2] fastboot: Add a module parameter to skip probing of
 specific ports
Message-ID: <20080812070222.3dc9efcb@infradead.org>
In-Reply-To: <20080812130027.2c4643a9@lxorguk.ukuu.org.uk>
References: <20080811153542.61095e5c@infradead.org>
	<20080811153641.706726ec@infradead.org>
	<20080812083903.6d402c2e@lxorguk.ukuu.org.uk>
	<20080812043603.3d8471d4@infradead.org>
	<20080812130027.2c4643a9@lxorguk.ukuu.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008 13:00:27 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > What
> > > defines the probe order here particularly as people are pushing
> > > for parallel probing of multiple devices.
> > 
> > the patches I'm pushing for this don't change probe order; that has
> > been tried before and wasn't a great success.
> 
> That was a question sorry. You are sledgehammering controllers by
> discovery sequence - you've no idea if they will always be found in
> that order. As such your boot option is incredibly fragile.

ok to answer your question;
today the probe order is consistent, at least on netbooks.
The admin or his installation program knows it when he has this (and if
linux were to grow full parallel probing it'll be optional, and if the
admin wants a fast boot he'll disable the parallel, reordering probe)
and can add the option for this case. It's the "push policy out of the
kernel" thing.. while the kernel probably can't know this (and you're
right, the DMI patch is thus the wrong thing to do).. the admin can.



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
