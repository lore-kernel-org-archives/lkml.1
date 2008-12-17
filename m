Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758263AbYLQKyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbYLQKyb (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 05:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYLQKyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 05:54:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43192 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbYLQKyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 05:54:19 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1229505475-10219-1-git-send-email-heukelum@fastmail.fm>
References: <1229505475-10219-1-git-send-email-heukelum@fastmail.fm>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        Alexander van Heukelum <heukelum@mailshack.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: PROC macro to annotate functions in assembly files
Date: Wed, 17 Dec 2008 10:53:53 +0000
Message-ID: <1636.1229511233@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> The goal is to annotate functions, at least those called
> from C code, with PROC at the beginning and ENDPROC at the
> end. This is for the benefit of debugging and tracing.

What about asm functions that have multiple entry points?

Take arch/mn10300/mm/cache-flush-mn10300.S for example.  Several functions in
there share bodies by virtue of falling through one to another.

David
