Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbXKGR2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbXKGR2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 12:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbXKGR2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 12:28:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbXKGR2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 12:28:34 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071107165300.6eeea2d8@the-village.bc.nu>
References: <20071107165300.6eeea2d8@the-village.bc.nu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH] frv: Remove bogus NO_IRQ = -1 define
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 07 Nov 2007 17:28:22 +0000
Message-ID: <30708.1194456502@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> The old NO_IRQ define some platforms had was long ago declared obsolete
> and wrong. FRV should therefore not be re-introducing this, especially as
> IRQs are usually unsigned in the kernel. The "no IRQ" case is defined to be
> zero and Linus made this rather clear at the time.
> 
> arch/frv shows no dependancy on this but it might show up driver fixes
> needing doing I guess

FRV doesn't use IRQ 0, so using 0 instead is fine.

Acked-by: David Howells <dhowells@redhat.com>
