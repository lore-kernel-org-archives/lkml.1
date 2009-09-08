Return-Path: <linux-kernel-owner+w=401wt.eu-S1751610AbZIHS4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbZIHS4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 14:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZIHS4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 14:56:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47944 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbZIHS4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 14:56:52 -0400
Date: Tue, 8 Sep 2009 15:56:22 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH RFC] char/tty_io: fix legacy pty name when more than 256
 pty devices are requested
Message-ID: <20090908155622.2308dc90@caramujo.chehab.org>
In-Reply-To: <20090908185926.042ba9aa@lxorguk.ukuu.org.uk>
References: <20090908144942.76ddf0e7@caramujo.chehab.org>
	<20090908185926.042ba9aa@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 8 Sep 2009 18:59:26 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> escreveu:

> > So, in order to allow more pty devices, the nomenclature were extended for
> > the devices with minor 256 or above. For those, the nomenclature will be:
> > 	ttyf0000-ttfpffff	(pty slave)
> > 	ptyf0000-ttyfffff	(pty master)
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> This fine and the namespace is free - but you need to update
> Documentation/devices.txt as well please.

Thanks for review. I'll document it and send a version 2 of the patch with the
devices.txt updated accordingly.



Cheers,
Mauro
