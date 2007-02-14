Return-Path: <linux-kernel-owner+w=401wt.eu-S932346AbXBNPz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346AbXBNPz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 10:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932350AbXBNPz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 10:55:58 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49390 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932346AbXBNPz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 10:55:58 -0500
Date: Wed, 14 Feb 2007 16:09:36 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: "Jan Beulich" <jbeulich@novell.com>
Cc: <alan@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC] adjust legacy IDE resource setting
Message-ID: <20070214160936.54b3c730@localhost.localdomain>
In-Reply-To: <45D33CF9.76E4.0078.0@novell.com>
References: <45D33344.76E4.0078.0@novell.com>
	<20070214154014.7fa76711@localhost.localdomain>
	<45D33CF9.76E4.0078.0@novell.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The masking is done primarily to (a) calculate the correct length (from a BAR's
> perspective), as I don't want to write the BAR if its length doesn't match the
> expectation, and (b) to properly report the new value in the printk.

Ok I guess you have to do something like that since you can't properly
encode BAR 1 and BAR 3.

> Of course I also opened a bug against X, as I too think it's doing something
> wrong here.

If you can add a comment about why it is done (X problem) then it looks
fine to me.

Alan
