Return-Path: <linux-kernel-owner+w=401wt.eu-S1031246AbXDQRKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031246AbXDQRKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 13:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031248AbXDQRKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 13:10:34 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40346 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031246AbXDQRKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 13:10:32 -0400
Date: Tue, 17 Apr 2007 18:13:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.21-rc6-mm1 ATA HPT37x regression
Message-ID: <20070417181340.7de99868@the-village.bc.nu>
In-Reply-To: <4624FE88.2010908@ru.mvista.com>
References: <17956.12963.163961.762444@smtp.charter.net>
	<4624D4C3.9010109@ru.mvista.com>
	<17956.63043.521397.597430@smtp.charter.net>
	<4624FE88.2010908@ru.mvista.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Ok, so do I need to do anything special with the next -mm release and
> > the next version?
> 
>    Well, let Alan decide that (2Alan: and I said that HPT code is bogus :-).

Try drivers/ide/pci/hpt366 - if that works grab a dmesg and let me know.
It means that Sergei's DPLL sync code seems to work better than the
vendor code and its time to swap it over.

Oh how I love highpoint PATA

Alan
