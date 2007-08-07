Return-Path: <linux-kernel-owner+w=401wt.eu-S935077AbXHGT1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935077AbXHGT1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 15:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbXHGT1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 15:27:35 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46959 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755878AbXHGT1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 15:27:33 -0400
Date: Tue, 7 Aug 2007 20:35:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070807203502.66b9ebda@the-village.bc.nu>
In-Reply-To: <46B8C016.6090806@tmr.com>
References: <20070803123712.987126000@chello.nl>
	<alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org>
	<20070804063217.GA25069@elte.hu>
	<20070804070737.GA940@elte.hu>
	<20070804103347.GA1956@elte.hu>
	<alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>
	<20070804163733.GA31001@elte.hu>
	<alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org>
	<46B4C0A8.1000902@garzik.org>
	<20070804191205.GA24723@lazybastard.org>
	<20070804192130.GA25346@elte.hu>
	<20070804211156.5f600d80@the-village.bc.nu>
	<46B4E161.9080100@garzik.org>
	<46B8C016.6090806@tmr.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> However, relatime has the POSIX behavior without the overhead. Therefore 

No. relatime has approximately SuS behaviour. Its not the same as
"correct" behaviour.

