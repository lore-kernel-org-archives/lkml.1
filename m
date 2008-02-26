Return-Path: <linux-kernel-owner+w=401wt.eu-S1758323AbYBZMzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323AbYBZMzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 07:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYBZMzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 07:55:37 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45262 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751453AbYBZMzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 07:55:36 -0500
Date: Tue, 26 Feb 2008 12:45:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@osdl.org, "Cai, Crane" <Crane.Cai@amd.com>
Subject: Re: GAK!!!! Re: PCI: AMD SATA IDE mode quirk
Message-ID: <20080226124506.681dfac9@core>
In-Reply-To: <47C346E2.10908@garzik.org>
References: <200802220059.m1M0xgjZ022717@hera.kernel.org>
	<20080222094828.2a0124ca@core>
	<47C346E2.10908@garzik.org>
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

> I agree.  I [obviously] missed this when I ack'd, mainly ack'ing the 
> overall change.
> 
> BIOS certainly may modify that PCI config register, but that's before 
> the kernel boots.  So, using pdev->class is fine.

I don't think the resume quirk is needed either as the core PCI
save/restore code rewrites the PCI registers so should be rewriting the
class back on resume as well.

