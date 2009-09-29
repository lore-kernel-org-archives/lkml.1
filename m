Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbZI2Skz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbZI2Skz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 14:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbZI2Sky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 14:40:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbZI2Skx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 14:40:53 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.01.0909290936430.6996@localhost.localdomain>
References: <alpine.LFD.2.01.0909290936430.6996@localhost.localdomain> <alpine.LFD.2.01.0909280743310.3349@localhost.localdomain> <20090928135332.4300.56046.stgit@warthog.procyon.org.uk> <20090928151628.62955233@lxorguk.ukuu.org.uk> <395.1254239745@redhat.com> <alpine.LFD.2.01.0909290909280.6996@localhost.localdomain>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove pty_ops_bsd and pty_bsd_ioctl() as they're not used
Date: Tue, 29 Sep 2009 19:40:10 +0100
Message-ID: <4079.1254249610@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Comments?

Perhaps add legacy pty support to the list of features to be removed and see
who howls.

>  static struct tty_driver *pty_driver, *pty_slave_driver;

These shouldn't be global variables.  They're only used within
legacy_pty_init().  That's a side issue, however.

Apart from that, it looks reasonable.

Acked-by: David Howells <dhowells@redhat.com>
