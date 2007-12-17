Return-Path: <linux-kernel-owner+w=401wt.eu-S935974AbXLQQVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935974AbXLQQVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933625AbXLQQVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:21:35 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45463 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932503AbXLQQVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:21:33 -0500
Date: Mon, 17 Dec 2007 16:13:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Filippos Papadopoulos <psybases@gmail.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: INITIO scsi driver fails to work properly
Message-ID: <20071217161353.0928b112@the-village.bc.nu>
In-Reply-To: <1197903781.3204.4.camel@localhost.localdomain>
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>
	<20071217031841.f483e5ac.akpm@linux-foundation.org>
	<20071217130523.7e9c88bb@the-village.bc.nu>
	<47668A75.7040707@panasas.com>
	<20071217143641.760d4162@the-village.bc.nu>
	<1197903781.3204.4.camel@localhost.localdomain>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, the change log isn't very committal for "rush me immediately into
> main line" plus, as far as I could dig out, there was no confirmation
> that it actually worked.  This way, I can now say please try the current

Without that change it always tries to use zero as the memory/io address
of the device.
