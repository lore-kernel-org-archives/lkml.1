Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbYKPPrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbYKPPrS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 10:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbYKPPrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 10:47:04 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39112 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750952AbYKPPrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 10:47:02 -0500
Date: Sun, 16 Nov 2008 15:46:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bernhard Walle <bwalle@suse.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       crash-utility@redhat.com
Subject: Re: [PATCH 3/3] Remove CONFIG_STRICT_DEVMEM
Message-ID: <20081116154657.6629e6bf@lxorguk.ukuu.org.uk>
In-Reply-To: <20081116162149.07f05c7c@kopernikus.site>
References: <1226846868-9595-1-git-send-email-bwalle@suse.de>
	<1226846868-9595-4-git-send-email-bwalle@suse.de>
	<20081116150901.4d824e6d@lxorguk.ukuu.org.uk>
	<20081116162149.07f05c7c@kopernikus.site>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> if just that patch doesn't make it, well, ok for me. I just think
> CONFIG_STRICT_DEVMEM is superfluous when the runtime configuration
> option is present.

It should always be "N" because the only other option means "add
pointless code of no value whatsoever"

Which means strict_devmem really belongs in the bitbucket as a bad idea

Alan


