Return-Path: <linux-kernel-owner+w=401wt.eu-S1759982AbZAMOHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982AbZAMOHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 09:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756970AbZAMOGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 09:06:50 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38186 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760938AbZAMOGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:06:48 -0500
Date: Tue, 13 Jan 2009 14:06:27 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [why oom_adj does not work] Re: Linux killed Kenny, bastard!
Message-ID: <20090113140627.507f15e1@lxorguk.ukuu.org.uk>
In-Reply-To: <20090113135246.GA29251@ioremap.net>
References: <20090112153304.GA19995@ioremap.net>
	<20090112154456.GA27269@redhat.com>
	<20090112154827.GB20743@ioremap.net>
	<20090112155108.2646b3ae@lxorguk.ukuu.org.uk>
	<20090113135246.GA29251@ioremap.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you _REALLY_ think anyone can calculate it yourself and then properly
> calculate adjustment used to properly select oom-killed process?

Its always a heuristic.

> So far my patch is the sanest way to deal with the OOM selection

No. You keep maintaining this but your crude hack is useless in a non
co-operative environment, has lots of issue with name aliasing and
doesn't deal with real needs.

We have container interfaces that can do this and far more and do them
right. In fact the very start of all the OpenVZ and container work years
ago was the beancounter patches which were addressed at exactly this
problem (although more specifically 'making sure undergraduates processes
get killed first')

Alan
