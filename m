Return-Path: <linux-kernel-owner+w=401wt.eu-S1762574AbYDXPa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762574AbYDXPa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761972AbYDXPTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:19:20 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44959 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761939AbYDXPTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:19:19 -0400
Date: Thu, 24 Apr 2008 15:50:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Tejun Heo <htejun@gmail.com>, jgarzik@pobox.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove ata_cable_sata()
Message-ID: <20080424155025.2bcf0f9b@the-village.bc.nu>
In-Reply-To: <20080424104406.GB2559@cs181133002.pp.htv.fi>
References: <20080421085131.GE26897@cs181133002.pp.htv.fi>
	<20080423192243.1f117215@the-village.bc.nu>
	<20080424104406.GB2559@cs181133002.pp.htv.fi>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I thought that you could simply set .flags in a driver without needing 
> any helper for .cable_detect .

In some cases yes, but exporting the complete set provides a logical and
complete API for drivers in case they do need to do so.
