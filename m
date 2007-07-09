Return-Path: <linux-kernel-owner+w=401wt.eu-S1757790AbXGIWVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790AbXGIWVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 18:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbXGIWVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 18:21:13 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37385 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754439AbXGIWVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 18:21:12 -0400
Date: Mon, 9 Jul 2007 23:27:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Backlund <tmb@mandriva.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Problem with SiS Ide/Pata/Sata on 2.6.22-rc7-git4
Message-ID: <20070709232742.004def28@the-village.bc.nu>
In-Reply-To: <4692A7C3.9030802@mandriva.org>
References: <4692A7C3.9030802@mandriva.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If you modprobe only sis5513
>   OR
> If you modprobe only sis5513 and then sata_sis/pata_sis:
>   - you get this:
>     (the hdb drive does not get detected/usable)

Don't mix old and new IDE like that. We allow both so you can use old SIS
and new Jmicron etc for example but there are some cases where trying to
load both old and new IDE support for the same chip will do strange
things.

Alan
