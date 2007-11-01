Return-Path: <linux-kernel-owner+w=401wt.eu-S1761059AbXKAWbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761059AbXKAWbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 18:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760726AbXKAWbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 18:31:32 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38432 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760428AbXKAWbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 18:31:31 -0400
Date: Thu, 1 Nov 2007 22:32:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, davem@redhat.com
Subject: Re: [IRDA] IRNET: Fix build when TCGETS2 is defined.
Message-ID: <20071101223253.6804abb8@the-village.bc.nu>
In-Reply-To: <200711011959.lA1JxPWc003735@hera.kernel.org>
References: <200711011959.lA1JxPWc003735@hera.kernel.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I'll go split the n_tty_ioctl stuff up and sort this cleanly for the
serial ppp and other users as well.  Will send a patch tomorrow that
makes ldisc catching of TCGET/SET calls unneccessary.

Alan
