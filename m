Return-Path: <linux-kernel-owner+w=401wt.eu-S1767355AbXCIQZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767355AbXCIQZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767359AbXCIQZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:25:52 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38560 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767355AbXCIQZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:25:51 -0500
Date: Fri, 9 Mar 2007 17:29:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2.6.22] remove Intel combined mode quirk
Message-ID: <20070309172947.79ef61bf@lxorguk.ukuu.org.uk>
In-Reply-To: <20070309160127.GA10226@havoc.gtf.org>
References: <20070309160127.GA10226@havoc.gtf.org>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>     Signed-off-by: Jeff Garzik <jeff@garzik.org>

Acked-by: Alan Cox <alan@redhat.com>

and you can remove even more code as pci_request_resources() will now
just do the right thing for all cases.

