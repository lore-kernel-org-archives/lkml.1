Return-Path: <linux-kernel-owner+w=401wt.eu-S1758907AbYHNUsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907AbYHNUsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 16:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbYHNUso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 16:48:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41023 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753700AbYHNUso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 16:48:44 -0400
Date: Thu, 14 Aug 2008 21:30:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] MAP_GROWSUP & MAP_GROWSDOWN removal
Message-ID: <20080814213053.0db0c59f@lxorguk.ukuu.org.uk>
In-Reply-To: <200808141519.m7EFJX9Z009294@devserv.devel.redhat.com>
References: <200808141519.m7EFJX9Z009294@devserv.devel.redhat.com>
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

> What is proposed here is to remove the flags real soon (2.6.29, as indicated
> below).  If this patch is accepted I will immediately remove the flags
> from the glibc headers.

The functionality is used by the kernel internally anyway so there is no
point removing it as it has no cost at all.

You can equally call "reboot" by mistake or strcpy with wrong parameters.
The interface is also part of our historic ABI/API so shouldn't just get
booted out.

You might not like it, and it might not be very useful but thats true of
stuff like readahead() as well.

Alan
