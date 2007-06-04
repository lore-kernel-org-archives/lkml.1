Return-Path: <linux-kernel-owner+w=401wt.eu-S1761562AbXFDTNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761562AbXFDTNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761295AbXFDTNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:13:34 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55116 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760624AbXFDTNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:13:33 -0400
Date: Mon, 4 Jun 2007 20:18:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't
 the kernel realize the BIOS has problems and re-map appropriately?
Message-ID: <20070604201823.7b7cb328@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0706041420100.25811@p34.internal.lan>
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan>
	<200706011407.51779.jbarnes@virtuousgeek.org>
	<20070601211943.GO7217@one.firstfloor.org>
	<200706011441.57149.jbarnes@virtuousgeek.org>
	<m1r6orwptz.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0706041420100.25811@p34.internal.lan>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Therefore, they are NOT going to fix their BIOS-- and I have already 
> received an e-mail from one or two people who are experiencing this 
> problem, I presume it will only get worse.

In which case we need to clip the memory used according to the MTRR
registers and tell the user xxMB of memory not available due to BIOS bugs

Alan
