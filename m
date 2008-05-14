Return-Path: <linux-kernel-owner+w=401wt.eu-S1762174AbYENOFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762174AbYENOFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 10:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757356AbYENOFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 10:05:24 -0400
Received: from vena.lwn.net ([206.168.112.25]:55606 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756241AbYENOFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 10:05:23 -0400
To: Timur Tabi <timur@freescale.com>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Add alloc_pages_exact() and free_pages_exact() 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Tue, 13 May 2008 16:26:46 CDT."
             <1210714006-8976-1-git-send-email-timur@freescale.com> 
Date: Wed, 14 May 2008 08:05:23 -0600
Message-ID: <16468.1210773923@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi writes:

> alloc_pages_exact() is similar to alloc_pages(), except that it allocates
> the minimum number of pages to fulfill the request.  This is useful if you
> want to allocate a very large buffer that is slightly larger than an
> even power-of-two number of pages.  In that case, alloc_pages() will waste
> a lot of memory.

FWIW, I wished I had something like this when doing the cafe_ccic
driver.  I can't really attest to the validity of the core VM stuff, but
I will say that the interface is worth having.

Thanks for doing this!

jon
