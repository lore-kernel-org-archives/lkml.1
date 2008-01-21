Return-Path: <linux-kernel-owner+w=401wt.eu-S1759627AbYAUQqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbYAUQqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 11:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbYAUQq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 11:46:28 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48232 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753240AbYAUQq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 11:46:26 -0500
Date: Mon, 21 Jan 2008 16:44:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Georgi Chulkov <g.chulkov@jacobs-university.de>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Mark Lord <liml@rtr.ca>
Subject: Re: ATA device reset, shoud I be concerned?
Message-ID: <20080121164414.6cd7d8fc@lxorguk.ukuu.org.uk>
In-Reply-To: <4794AD3F.40309@gmail.com>
References: <200801140019.20668.g.chulkov@jacobs-university.de>
	<20080115025435.1e21b703.akpm@linux-foundation.org>
	<20080115113552.75731bf8@lxorguk.ukuu.org.uk>
	<4794501E.90306@gmail.com>
	<20080121130256.2443d7c1@lxorguk.ukuu.org.uk>
	<47949AA4.9090601@gmail.com>
	<20080121141425.45aa9c61@lxorguk.ukuu.org.uk>
	<4794ACAF.70505@gmail.com>
	<4794AD3F.40309@gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just a data point, even ICHs lock up after PHY event if the wrong TF
> register is accessed.  I just don't think tempting with TF regs after
> timeout is worth the cost.

For SATA maybe, for PATA I don't have any controllers with your bug so
its wrong for libata to cripple the PATA support or working controllers.

Alan
