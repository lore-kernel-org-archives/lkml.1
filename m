Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbYE2Sn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbYE2Sn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYE2SnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:43:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58573 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751341AbYE2SnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:43:20 -0400
Date: Thu, 29 May 2008 19:29:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: RESEND: [PATCH] libata-sff: Fix oops reported in kerneloops.org
 for pnp devices with no ctl
Message-ID: <20080529192916.0c1cdb02@core>
In-Reply-To: <alpine.LFD.1.10.0805291102370.2958@woody.linux-foundation.org>
References: <20080529161453.24735.805.stgit@core>
	<alpine.LFD.1.10.0805290950230.2958@woody.linux-foundation.org>
	<483EEBE5.5030708@garzik.org>
	<alpine.LFD.1.10.0805291102370.2958@woody.linux-foundation.org>
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

> So it's "ata_sdd_sync()" that I think is bogus. Based on its name alone, 
> it shouldn't have a delay in it (except, as mentioned, possibly for the 
> fallback case where no port can be used for reading).

It should indeed not have the delay in it.

Alan
