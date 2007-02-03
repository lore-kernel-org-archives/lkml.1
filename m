Return-Path: <linux-kernel-owner+w=401wt.eu-S1751315AbXBCToO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315AbXBCToO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 14:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbXBCToO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 14:44:14 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57961 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751315AbXBCToN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 14:44:13 -0500
Date: Sat, 3 Feb 2007 19:56:07 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Bodo Eggert <7eggert@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Andrew Morton <akpm@osdl.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH/RFC] alternative aproach to: Ban module license tag
 string termination trick
Message-ID: <20070203195607.1db92edd@localhost.localdomain>
In-Reply-To: <20070203081426.GA10520@flint.arm.linux.org.uk>
References: <Pine.LNX.4.58.0702022216120.25199@be1.lrz>
	<20070203081426.GA10520@flint.arm.linux.org.uk>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Feb 2007 08:14:26 +0000
Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> On Sat, Feb 03, 2007 at 03:08:14AM +0100, Bodo Eggert wrote:
> > This patch changes the module license handling code to:
> > - prevent the "GPL\0 for nothing"-trick
> 
> You can achieve this effect without changing the existing module
> format, and it's far more difficult to bypass with build-with-
> modified module.h tricks.

Nice, this should go in anyway.

Acked-by: Alan Cox <alan@redhat.com>
