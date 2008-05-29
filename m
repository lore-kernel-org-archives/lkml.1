Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbYE2TIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbYE2TIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 15:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYE2TIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 15:08:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbYE2TIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 15:08:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080529182853.GA32180@cs181133002.pp.htv.fi>
References: <20080529182853.GA32180@cs181133002.pp.htv.fi> <20080529181726.5396.79336.stgit@warthog.procyon.org.uk> <20080529181736.5396.28119.stgit@warthog.procyon.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] Werror: Remove iiEllisCleanup() as it's unused.
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 29 May 2008 20:07:49 +0100
Message-ID: <2170.1212088069@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> wrote:

> It is used with CONFIG_COMPUTONE=m - this empty function is kinda 
> pointless but you also have to remove the caller from ip2main.c if
> you want to remove it.

Ah...  I see.  i2ellis.c is #included by ip2main.c, but iiEllisCleanup() isn't
called unless actually in a module.

David
