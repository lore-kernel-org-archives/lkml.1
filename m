Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbYE3QD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbYE3QD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 12:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbYE3QDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 12:03:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56495 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752060AbYE3QDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 12:03:18 -0400
Date: Fri, 30 May 2008 16:48:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Oliver Neukum <oliver@neukum.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Michael Zappe <zapman@interlan.net>,
       Stephane Alnet <stephane@u-picardie.fr>,
       Brad Hards <bhards@bigpond.net.au>
Subject: Re: [PATCH] kaweth: use request_firmware()
Message-ID: <20080530164842.31b23848@core>
In-Reply-To: <FD896A2C-277F-45CF-AE26-E2E29DA8093F@holtmann.org>
References: <1211708969@pmac.infradead.org>
	<1212070841.26088.28.camel@shinybook.infradead.org>
	<200805301555.59327.oliver@neukum.org>
	<1212160598.8199.6.camel@shinybook.infradead.org>
	<FD896A2C-277F-45CF-AE26-E2E29DA8093F@holtmann.org>
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

> we tried to not put that policy into the drivers and I was looking  
> over this, but in the meantime driver slipped past me and made it in.  
> We should not do this at all and if people wanna have this, then they  
> should solve this within udev.

Then you arrived at the party a year too late. The format name/firmware
is commonly used all over the kernel. How that maps to a file or
directory is indeed a matter for udev, but there is already a
heirarchical namespace and pretending otherwise won't help.

Alan
