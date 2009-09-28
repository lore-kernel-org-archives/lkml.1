Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbZI1O46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbZI1O46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 10:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbZI1O45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 10:56:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbZI1O45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 10:56:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090928151628.62955233@lxorguk.ukuu.org.uk>
References: <20090928151628.62955233@lxorguk.ukuu.org.uk> <20090928135332.4300.56046.stgit@warthog.procyon.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove pty_ops_bsd and pty_bsd_ioctl() as they're not used
Date: Mon, 28 Sep 2009 15:55:44 +0100
Message-ID: <7306.1254149744@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Possibly legacy_pty_init() should be passing this to tty_set_operations()
> > rather than pty_ops.
> 
> It should indeed, otherwise the BSD pty locking ioctl fails.

In that case, what should be using pty_ops?  If CONFIG_LEGACY_PTYS=n, then I
see:

	drivers/char/pty.c:314: warning: unused variable `pty_ops'

David
