Return-Path: <linux-kernel-owner+w=401wt.eu-S933954AbZJMQFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933954AbZJMQFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 12:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760454AbZJMQFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 12:05:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760452AbZJMQFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 12:05:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1255432821-1104-1-git-send-email-vapier@gentoo.org>
References: <1255432821-1104-1-git-send-email-vapier@gentoo.org> <32310.1255428618@redhat.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: dhowells@redhat.com, uclinux-dev@uclinux.org,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Jie Zhang <jie.zhang@analog.com>, Robin Getz <rgetz@analog.com>
Subject: Re: [PATCH v2] NOMMU: fix malloc performance by adding uninitialized flag
Date: Tue, 13 Oct 2009 17:03:42 +0100
Message-ID: <3372.1255449822@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier@gentoo.org> wrote:

> +	bool "Allow mmaped anonymous memory to be un-initialized"

Can you change that to be 'mmapped' and 'uninitialized'?

Other than that, it looks good.

David
