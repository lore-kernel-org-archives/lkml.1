Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbYEYUKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbYEYUKq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 16:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757632AbYEYUKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 16:10:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42997 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757137AbYEYUKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 16:10:37 -0400
Date: Sun, 25 May 2008 20:53:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Alexandre Oliva <aoliva@redhat.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Takashi Iwai <tiwai@suse.de>,
       Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Message-ID: <20080525205331.48055798@core>
In-Reply-To: <4A84E98F-1C0D-4194-AC63-5455CCD5DD35@holtmann.org>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	<1211550374.28967.10.camel@pmac.infradead.org>
	<20080523164108.GA31545@uranus.ravnborg.org>
	<1211640377.540.14.camel@pmac.infradead.org>
	<20080524152214.GA12582@uranus.ravnborg.org>
	<1211642706.31212.85.camel@shinybook.infradead.org>
	<1211643245.31212.88.camel@shinybook.infradead.org>
	<D56F641E-9FDB-48E5-AF0B-B8E84B08504A@holtmann.org>
	<1211707837.17151.14.camel@johannes.berg>
	<95BCF0F0-755A-4501-9B44-B421AD3E8F42@holtmann.org>
	<orej7q1ewq.fsf@oliva.athome.lsd.ic.unicamp.br>
	<4A84E98F-1C0D-4194-AC63-5455CCD5DD35@holtmann.org>
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

> And again the grouping into subdirectories should have been fixed in  
> userspace by reading the driver name. The kernel should not do this at  
> all.

The kernel should carry on doing what it does at the moment. The amount
of gain from semi-pointless screwing about with the namespace and
compatibility is vastly less than the gain from leaving things in their
current perfectly happy and adequate form.

Alan
