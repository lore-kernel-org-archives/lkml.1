Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbYBRPDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbYBRPDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbYBRPDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 10:03:03 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51451 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752392AbYBRPDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:03:01 -0500
Date: Mon, 18 Feb 2008 14:54:27 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Cc: Omar Kilani <omar.kilani@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: aacraid: Host adapter reset request. SCSI hang ?
Message-ID: <20080218145427.21614b08@core>
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F4399FCFAF@ADPE2K703.adaptec.com>
References: <f0cc3e3e0802152238t59498e3bv229d02ee3d96cea7@mail.gmail.com>
	<532ABFBDAAC3A34EB12EBA6CEC2838F4399FCFAF@ADPE2K703.adaptec.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> pattern between the controller and Linux' SCSI subsystem. The alternate workaround is for the user to adjust the timeout in sysfs if it is shorter than this value. This is the only

Does that actually work. I consistently see libata reporting 60 seconds
but the commands are on 30 second timeouts and I've yet to get to the
bottom of this
