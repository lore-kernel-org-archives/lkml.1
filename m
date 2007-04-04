Return-Path: <linux-kernel-owner+w=401wt.eu-S966256AbXDDBg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966256AbXDDBg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966250AbXDDBf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:35:58 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58032 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S966244AbXDDBf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:35:28 -0400
Date: Wed, 4 Apr 2007 02:38:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Brad Boyer <flar@allandria.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070404023822.53aabc1a@the-village.bc.nu>
In-Reply-To: <20070403230908.GA13471@cynthia.pants.nu>
References: <1175610345.2665.15.camel@shinybook.infradead.org>
	<17938.57292.870224.132415@cargo.ozlabs.ibm.com>
	<1175642916.10567.24.camel@shinybook.infradead.org>
	<20070403212928.GA12951@cynthia.pants.nu>
	<1175644642.10567.31.camel@shinybook.infradead.org>
	<20070403221002.GA13210@cynthia.pants.nu>
	<1175648051.10567.61.camel@shinybook.infradead.org>
	<20070403230908.GA13471@cynthia.pants.nu>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> my opinion. I do understand that 8250 compatible chips are very common
> and are the most likely serial chips to be used with Linux. However, I
> will point out that the define is TTY_MAJOR, not 8250_MAJOR. It seems
> to me that whoever named it was thinking in more generic terms.

The define goes back the very first days of Linux. I doubt whoever named
it (Linus I imagine) had even considered that anyone else might be
running his terminal emulator at that point.

