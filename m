Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab0BKVIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 16:08:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756986Ab0BKVI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 16:08:29 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1265880960-26676-1-git-send-email-vapier@gentoo.org>
References: <1265880960-26676-1-git-send-email-vapier@gentoo.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: dhowells@redhat.com, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org
Subject: Re: [PATCH] ptrace: unify FDPIC implementations
Date: Thu, 11 Feb 2010 21:07:49 +0000
Message-ID: <15265.1265922469@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier@gentoo.org> wrote:

> The Blackfin/FRV/SuperH guys all have the same exact FDPIC ptrace code in
> their arch handlers (since they were probably copied & pasted).  Since
> these ptrace interfaces are an arch independent aspect of the FDPIC code,
> unify them in the common ptrace code so new FDPIC ports don't need to copy
> and paste this fundamental stuff yet again.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Acked-by: David Howells <dhowells@redhat.com>
