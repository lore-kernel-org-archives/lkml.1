Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbXKKQcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbXKKQcX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 11:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbXKKQcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 11:32:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764AbXKKQcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 11:32:14 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200711111646.27496.ak@suse.de>
References: <200711111646.27496.ak@suse.de> <20071111142205.GO21669@stusta.de> <1701.1194793436@redhat.com> <20071111151951.GP21669@stusta.de>
To: Andi Kleen <ak@suse.de>
Cc: dhowells@redhat.com, Adrian Bunk <bunk@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
Subject: Re: [PATCH 1/6] Suppress A.OUT library support if !CONFIG_BINFMT_AOUT [try #5]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Sun, 11 Nov 2007 16:31:53 +0000
Message-ID: <2393.1194798713@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> wrote:

> One problem is that EXPORT_SYMBOL always creates a reference to the function
> even when nothing uses it.

Exactly.  This function is for use in something that can be compiled as a
module, therefore this sort of thing is academic - unless we take away the
ability of the aout binfmt to be built as a module.

What's wrong, anyway, with inlining the function?

David
