Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbYLFXhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbYLFXhJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 18:37:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbYLFXg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 18:36:58 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35349 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752844AbYLFXg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 18:36:57 -0500
Date: Sat, 6 Dec 2008 23:35:07 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>, Takashi Iwai <tiwai@suse.de>,
       Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/3] PCI: Rework default handling of suspend
 and resume
Message-ID: <20081206233507.205b8ea5@lxorguk.ukuu.org.uk>
In-Reply-To: <20081206152545.326c8b67@infradead.org>
References: <Pine.LNX.4.44L0.0812061324260.13426-100000@netrider.rowland.org>
	<200812062236.44111.rjw@sisk.pl>
	<alpine.LFD.2.00.0812061420190.3425@nehalem.linux-foundation.org>
	<20081206152545.326c8b67@infradead.org>
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

> So we need to unregister + re-register to make that happen

Agreed - and to cope with coming back up with some masked IRQs for those
lovely hardware vendors whose idea of amusement is handing the resumed
system a pending IRQ. To be fair its often hardware flagging things like
'device has become ready' from power up events...

