Return-Path: <linux-kernel-owner+w=401wt.eu-S1762263AbZLPQ77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762263AbZLPQ77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 11:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbZLPQ76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 11:59:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbZLPQ74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 11:59:56 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1260921350-6539-1-git-send-email-vapier@gentoo.org>
References: <1260921350-6539-1-git-send-email-vapier@gentoo.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: dhowells@redhat.com, uclinux-dev@uclinux.org,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NOMMU: add [stack] label to per-process maps output
Date: Wed, 16 Dec 2009 16:59:29 +0000
Message-ID: <20419.1260982769@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier@gentoo.org> wrote:

> +		if (vma->vm_start <= mm->start_brk &&
> +				vma->vm_end >= mm->brk) {

Hmmm...  That ought to involve mm->start_stack somewhere...  (Or, more
probably, task->stack_start:-/)

David
