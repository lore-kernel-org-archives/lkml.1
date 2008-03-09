Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbYCILVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbYCILVS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 07:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYCILVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 07:21:08 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57351 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752501AbYCILVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 07:21:08 -0400
Date: Sun, 9 Mar 2008 11:08:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Dave Young" <hidave.darkstar@gmail.com>
Cc: "Johannes Weiner" <hannes@saeurebad.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] add time_now_after and other macros which compare
 with jiffies
Message-ID: <20080309110808.2249aa3a@core>
In-Reply-To: <a8e1da0803090344l7f468326r8d3844e20ede08a3@mail.gmail.com>
References: <200803080735.06984.hidave.darkstar@gmail.com>
	<877igd6vqn.fsf@saeurebad.de>
	<a8e1da0803081654l50fdda44jbbed1d1ed2caf9ae@mail.gmail.com>
	<20080309095802.70d91c7b@core>
	<a8e1da0803090344l7f468326r8d3844e20ede08a3@mail.gmail.com>
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

> Yes, This has a purpose as well. You will find most of the usage of these
> macros are just compare some value with jiffies after doing some grep.

That is no reason to add more macros that hide how they do it, or make
jiffies itself invisible to the grep search or variable usage finding
tools (and for tickless that very thing is important)

> For these cases this adding will easy use and understand.

It hides information.

Alan
