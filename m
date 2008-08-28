Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbYH1RIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbYH1RIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbYH1RIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:08:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33510 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751776AbYH1RIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:08:13 -0400
Date: Thu, 28 Aug 2008 17:51:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: david@lang.hm
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: question about overcommit
Message-ID: <20080828175100.3c3cda9e@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.1.10.0808280952010.2713@asgard.lang.hm>
References: <alpine.DEB.1.10.0808280952010.2713@asgard.lang.hm>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> my belief from watching the discussions is that it will evict things from 
> ram to make space for the new allocation, and as a result running with 
> overcommit disabled ends up wasting a noticable amount of ram. As a result 

No-overcommit is address space accounting alone. It doesn't change actual
allocation or management of memory, it simply ensures that there should
always be enough space to ensure it can sort itself out without having to
OOM something.

It's a bit like bank loans - providing I know how much money is available
I don't have to do much except for ensure the total loaned is covered. In
the overcommit mode we instead run like the US banking system and pray we
don't hit a messy OOM (out of money) situation.

Alan
