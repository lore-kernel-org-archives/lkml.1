Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbYAPUV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbYAPUV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 15:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYAPUVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 15:21:49 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58064 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751672AbYAPUVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 15:21:48 -0500
Date: Wed, 16 Jan 2008 20:05:28 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: "Daniel Phillips" <phillips@google.com>, "Al Boldi" <a1426z@gawab.com>,
       "David Chinner" <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       "Pavel Machek" <pavel@ucw.cz>, "Rik van Riel" <riel@redhat.com>,
       "Theodore Tso" <tytso@mit.edu>, "Valerie Henson" <val.henson@gmail.com>
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental
 fsck)
Message-ID: <20080116200528.4629ad80@lxorguk.ukuu.org.uk>
In-Reply-To: <OFDB679999.9793D1C7-ON882573D2.00646D05-882573D2.0068FF85@us.ibm.com>
References: <4d47a5d10801151724m418e18efp9a0dd936e9a3584c@mail.gmail.com>
	<OFDB679999.9793D1C7-ON882573D2.00646D05-882573D2.0068FF85@us.ibm.com>
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

> And I think there's a problem with drives that, upon sensing the 
> unreadable sector, assign an alternate even though the sector is fine, and 
> you eventually run out of spares.

You are assuming drives can't tell the difference between stray data loss
and sectors that can't be recovered by rewriting and reuse. I was under
the impression modern drives could do this ?

Alan
