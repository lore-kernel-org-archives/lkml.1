Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbZD2Jqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbZD2Jqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbZD2Jqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:46:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35487 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbZD2Jqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:46:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090429090654.GA8234@redhat.com>
References: <20090429090654.GA8234@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, kpm@redhat.com, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] elf_core_dump: use rcu_read_lock() to access ->real_parent
Date: Wed, 29 Apr 2009 10:46:43 +0100
Message-ID: <7146.1240998403@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> (on top of ptrace-s-parent-real_parent-in-binfmt_elf_fdpicc.patch)
> 
> In theory it is not safe to dereference ->parent/real_parent without
> tasklist or rcu lock, we can race with re-parenting.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: David Howells <dhowells@redhat.com>
