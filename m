Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbYEZVLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbYEZVLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 17:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbYEZVLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 17:11:15 -0400
Received: from smtp7-g19.free.fr ([212.27.42.64]:39413 "EHLO smtp7-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067AbYEZVLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 17:11:14 -0400
Message-ID: <1ed501c8bf74$95dd02a0$f9b5a8c0@pii350>
From: "Gilles Espinasse" <g.esp@free.fr>
To: "Theodore Tso" <tytso@MIT.EDU>, <linux-kernel@vger.kernel.org>
Cc: "Chris Peterson" <cpeterso@cpeterso.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
       "Jeff Garzik" <jeff@garzik.org>, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "Rick Jones" <rick.jones2@hp.com>, "Glen Turner" <gdt@gdt.id.au>
References: <482C7E53.3050300@hp.com> <482C8184.2030906@garzik.org> <482C8550.5000909@intel.com> <482C8D4D.3040702@garzik.org> <20080516132107.GA11304@csclub.uwaterloo.ca> <20080516161029.44ded734@core> <20080516173610.GA27126@csclub.uwaterloo.ca> <20080516191125.46 <20080525232712.GF5970@mit.edu>
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of IRQF_SAMPLE_RANDOM
Date: Mon, 26 May 2008 23:08:02 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1914
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1914
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----- 
From: "Theodore Tso" <tytso@MIT.EDU>
To: "Glen Turner" <gdt@gdt.id.au>
Cc: "Chris Peterson" <cpeterso@cpeterso.com>; "Alan Cox"
<alan@lxorguk.ukuu.org.uk>; "Lennart Sorensen"
<lsorense@csclub.uwaterloo.ca>; "Jeff Garzik" <jeff@garzik.org>; "Kok, Auke"
<auke-jan.h.kok@intel.com>; "Rick Jones" <rick.jones2@hp.com>; "Brandeburg,
Jesse" <jes>
Sent: Monday, May 26, 2008 1:27 AM
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of
IRQF_SAMPLE_RANDOM


...
>
> There is a reason why /dev/random is world-writeable; it's perfectly
> safe to write arbitary amounts of data into /dev/random.  If the
> attacker doesn't know what has been fixed into the entropy pool, his
> life just got a lot harder.  If it is the attacker mixing known data
> into the pool, it's no worse.
>
man 4 random recommand to save /dev/urandom during stop and seed
/dev/urandom at start.
For wich reason is it not recommanded to save and seed using /dev/random?

Gilles

