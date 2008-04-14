Return-Path: <linux-kernel-owner+w=401wt.eu-S1762181AbYDNVil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762181AbYDNVil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 17:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755736AbYDNVie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 17:38:34 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49290 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753734AbYDNVid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 17:38:33 -0400
Date: Mon, 14 Apr 2008 22:34:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rogan Dawes <lists@dawes.za.net>
Cc: Adrian Bunk <bunk@kernel.org>, chris@zankel.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] xtensa: don't offer PARPORT_PC
Message-ID: <20080414223409.5ae3271c@core>
In-Reply-To: <4803BF9D.4070304@dawes.za.net>
References: <20080414195551.GE26885@cs181133002.pp.htv.fi>
	<4803BF9D.4070304@dawes.za.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Pardon a possibly stupid question here, but would it not make more sense 
> to code the architectures for which these various devices *are* 
> possible, rather than requiring each architecture to go through the 
> entire config file and add their own "we don't do this" for many entries?

For any with PCI bus the right fix is to add the header files.
-- 
--
	"Alan, I'm getting a bit worried about you."
				-- Linus Torvalds
