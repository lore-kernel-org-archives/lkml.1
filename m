Return-Path: <linux-kernel-owner+w=401wt.eu-S1763893AbYBZSRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763893AbYBZSRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 13:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756341AbYBZSQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 13:16:58 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41704 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754324AbYBZSQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 13:16:57 -0500
Date: Tue, 26 Feb 2008 18:04:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Alan Cox <alan@redhat.com>, davids@webmaster.com, Valdis.Kletnieks@vt.edu,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.6.25-rc2-mm1 - fix mcount GPL bogosity.
Message-ID: <20080226180452.266615da@core>
In-Reply-To: <m34pbvsjd9.fsf@maximus.localdomain>
References: <MDEHLPKNGKAHNMBLJOLKGEKDKKAC.davids@webmaster.com>
	<m3d4qj90zm.fsf@maximus.localdomain>
	<m34pbv8x8s.fsf@maximus.localdomain>
	<20080226172143.GA5445@devserv.devel.redhat.com>
	<m34pbvsjd9.fsf@maximus.localdomain>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > From what I've seen its helped make binary
> > module abusers more cautious.
> 
> Those not using _GPL exports?

In general. To be honest there is very little binary only stuff left now
