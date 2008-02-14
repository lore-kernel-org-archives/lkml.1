Return-Path: <linux-kernel-owner+w=401wt.eu-S934028AbYBNWjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934028AbYBNWjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 17:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757404AbYBNWjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 17:39:14 -0500
Received: from khc.piap.pl ([195.187.100.11]:42332 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbYBNWjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 17:39:12 -0500
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Newall <davidn@davidnewall.com>,
       Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Handshaking on USB serial devices
References: <47B30291.2040905@davidnewall.com>
	<47B40918.20206@davidnewall.com> <20080214121026.16a9c510@core>
	<200802141116.14722.gene.heskett@gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 14 Feb 2008 23:39:09 +0100
In-Reply-To: <200802141116.14722.gene.heskett@gmail.com> (Gene Heskett's message of "Thu\, 14 Feb 2008 11\:16\:14 -0500")
Message-ID: <m3k5l7uprm.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett <gene.heskett@gmail.com> writes:

> Apparently they do not Alan, the pl2303 in particular is a problem child, 
> throwing several lost com errors a day when doing nothing more strenuous than 
> talking to my belkin UPS from apcupsd, very small packets there, 20 bytes I 
> believe at several second intervals.

Is your UPS using "modern" hardware handshaking (CTS = PC can send,
with RTS practically always asserted)? Or perhaps the "old",
"half-duplex" V.24-style (RTS asserted before TX and then waiting for
CTS)?

Are you sure it uses hw handshaking at all? Most (all?) UPSes I used
had only TxD and RxD (for RS-232).
-- 
Krzysztof Halasa
