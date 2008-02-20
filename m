Return-Path: <linux-kernel-owner+w=401wt.eu-S1765188AbYBTNBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765188AbYBTNBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 08:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765017AbYBTNBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 08:01:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765016AbYBTNBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 08:01:12 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080218200302.GA6741@cvg>
References: <20080218200302.GA6741@cvg>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: dhowells@redhat.com, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUESTION] FRV: linking error?
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 20 Feb 2008 13:01:05 +0000
Message-ID: <19148.1203512465@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> being see over vmlinux.lds for FRV architecture I found the string:
> 
> 	. = ALIGN(4096);
> 	.data.page_aligned : { *(.data.idt) }
> 
> though the PAGE_SIZE is 16K. Can't figure out why is that...
> Do you have a few spare minutes to explain, please?

Ummm...  Good question.  Probably a legacy thing.  I think the .data.idt
section is also an x86-only thing and should be dispensed with for FRV.
Leastways, the section has nothing in it according to the link map.

David
