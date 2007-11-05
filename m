Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbXKEWqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbXKEWqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 17:46:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbXKEWp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 17:45:57 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35897 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750741AbXKEWp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 17:45:56 -0500
Date: Mon, 5 Nov 2007 22:46:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tobias Hoffmann <lk-list@the-axe-effect.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: drive side 80-wire cable detection failed
Message-ID: <20071105224631.5befab14@the-village.bc.nu>
In-Reply-To: <472D13A4.5080906@the-axe-effect.de>
References: <472CFFBD.2050007@the-axe-effect.de>
	<20071103232040.33a2fa09@the-village.bc.nu>
	<472D13A4.5080906@the-axe-effect.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> As far as I understood it, pata_acpi should fix the problem, but I'm not 
> sure on the required configuration. Do I have to disable the normal 
> IDE-support? How 'experimental' is the PATA support?

The pata_amd (AMD/Nvidia) driver is pretty robust, but I would expect the
same results from both in your case at the moment. Tejun is still fixing
ACPI bits so after that it might be worth trying.

Alan
