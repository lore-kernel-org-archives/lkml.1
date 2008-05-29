Return-Path: <linux-kernel-owner+w=401wt.eu-S1758965AbYE2TZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758965AbYE2TZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 15:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756189AbYE2TZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 15:25:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756071AbYE2TZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 15:25:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080529121942.b6d768e7.akpm@linux-foundation.org>
References: <20080529121942.b6d768e7.akpm@linux-foundation.org> <20080529181726.5396.79336.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, bunk@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Werror: Fix casting wrong size integer to pointer
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 29 May 2008 20:25:24 +0100
Message-ID: <17009.1212089124@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> yup, what Linus said.  This one's been irritating me for years, and I
> got close to tempting Markus into fixing it before he departed the
> scene.  But it remains, as a little "might be busted on 64 bit" reminder.

Is it worth making the driver only available for non-64-bit arches?

David
