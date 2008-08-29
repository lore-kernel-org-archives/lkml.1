Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbYH2Su7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbYH2Su7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 14:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbYH2Sut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 14:50:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52065 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751342AbYH2Sus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 14:50:48 -0400
Date: Fri, 29 Aug 2008 19:33:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@tglx.de
Subject: Re: [PATCH 4/5] select: make select() use schedule_hrtimeout()
Message-ID: <20080829193309.113d5b64@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.1.10.0808291140010.3300@nehalem.linux-foundation.org>
References: <20080829080549.6906b744@infradead.org>
	<20080829080809.0e42a323@infradead.org>
	<alpine.LFD.1.10.0808290915560.3300@nehalem.linux-foundation.org>
	<20080829171108.63e6dcd4@lxorguk.ukuu.org.uk>
	<alpine.LFD.1.10.0808291009450.3300@nehalem.linux-foundation.org>
	<20080829191837.3d2b3050@lxorguk.ukuu.org.uk>
	<alpine.LFD.1.10.0808291140010.3300@nehalem.linux-foundation.org>
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

> And yes, I do agree that the heuristic could well involve other 
> characteristics of the process in question. And probably characteristics 
> of the machine itself (ie some general kind of "power mode" where timers 
> are simply not considered critical if you want to be in low-power mode).

HAL and dbus already deal with this sort of stuff, including now having a
notion of 'on battery' and the like so if its in sysfs it ceases to be
the kernels problem ;)
