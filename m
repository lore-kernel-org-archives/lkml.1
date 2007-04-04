Return-Path: <linux-kernel-owner+w=401wt.eu-S2992592AbXDDFCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992592AbXDDFCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 01:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992594AbXDDFCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 01:02:40 -0400
Received: from ozlabs.org ([203.10.76.45]:40446 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992592AbXDDFCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 01:02:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17939.10130.687893.167511@cargo.ozlabs.ibm.com>
Date: Wed, 4 Apr 2007 14:20:34 +1000
From: Paul Mackerras <paulus@samba.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Brad Boyer <flar@allandria.com>, David Woodhouse <dwmw2@infradead.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
In-Reply-To: <20070404022544.59b022a6@the-village.bc.nu>
References: <1175610345.2665.15.camel@shinybook.infradead.org>
	<17938.57292.870224.132415@cargo.ozlabs.ibm.com>
	<1175642916.10567.24.camel@shinybook.infradead.org>
	<20070403212928.GA12951@cynthia.pants.nu>
	<20070404022544.59b022a6@the-village.bc.nu>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox writes:

> That would be completely unmanagable on many systems with multiport
> controllers and interfaces where the naming tells you things like which
> cable port off which socket off which multiplexor is the one you are
> talking about.

I never suggested *all* serial ports should be /dev/ttySn, I said that
the built-in ports on the motherboard should be /dev/ttySn.  The
built-in ports can generally be enumerated early on boot in a stable
order, and they should be assigned the low ttySn numbers, regardless
of what chip is used to implement them.

Paul.
