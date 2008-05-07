Return-Path: <linux-kernel-owner+w=401wt.eu-S1762873AbYEGHtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762873AbYEGHtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762412AbYEGHsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:48:54 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38747 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758454AbYEGHsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:48:51 -0400
Date: Wed, 7 May 2008 08:39:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Cc: "Yigal Sadgat" <YSadgat1@gcte.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, jwboyer@linux.vnet.ibm.com, joern@logfs.org
Subject: Re: Compact Flash Question
Message-ID: <20080507083917.6eebf110@core>
In-Reply-To: <e2e108260805062315n15e84abck5f4207a6a7a11805@mail.gmail.com>
References: <005b01c8afc4$77f4ec90$6401a8c0@techwriter>
	<e2e108260805062315n15e84abck5f4207a6a7a11805@mail.gmail.com>
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

> For most Linux filesystems you really need wear leveling. E.g. ext3's
> superblock is at a fixed location and gets overwritten frequently.
> Without wear leveling you risk that the flash sector where the
> superblock resides wears out early.

CF sector mappings are not simple 1:1 mappings with flash blocks so this
is not the case. It is true with raw flash but not with CF. What CF
requires is vendor dependent but most vendors are pretty sensible.

The noatime advice is however good.
