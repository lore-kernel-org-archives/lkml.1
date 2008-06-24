Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbYFXKVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbYFXKVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 06:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYFXKVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 06:21:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbYFXKVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 06:21:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0806241021080.26777@ask.diku.dk>
References: <Pine.LNX.4.64.0806241021080.26777@ask.diku.dk>
To: Julia Lawall <julia@diku.dk>
Cc: dhowells@redhat.com, akinobu.mita@gmail.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/14] arch/frv: Eliminate NULL test and memset after alloc_bootmem
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 24 Jun 2008 11:21:16 +0100
Message-ID: <7115.1214302876@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <julia@diku.dk> wrote:

> As noted by Akinobu Mita in patch b1fceac2b9e04d278316b2faddf276015fc06e3b,
> alloc_bootmem and related functions never return NULL and always return a
> zeroed region of memory.  Thus a NULL test or memset after calls to these
> functions is unnecessary.

Acked-by: David Howells <dhowells@redhat.com>
