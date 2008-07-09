Return-Path: <linux-kernel-owner+w=401wt.eu-S1752535AbYGIQnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbYGIQnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbYGIQm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:42:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbYGIQm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:42:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080709164929.799e4e05@the-village.bc.nu>
References: <20080709164929.799e4e05@the-village.bc.nu> <E1KGa1W-0004nG-Cw@n2o.xs4all.nl> <20080709113547.19235.15424.stgit@warthog.procyon.org.uk> <4561.1215612914@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, "Miquel van Smoorenburg" <miquels@cistron.nl>,
       akpm@linux-foundation.org, alan@redhat.com,
       Markus.Lidel@shadowconnect.com, vvs@sw.ru, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Mark i2o config broken on 64-bit platforms.
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Wed, 09 Jul 2008 17:42:37 +0100
Message-ID: <7286.1215621757@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Agreed - stick | GFP_DMA32 on the end then ;)

Ummm... Does that actually work on kmalloc()?  Or only on alloc_pages()?

David
