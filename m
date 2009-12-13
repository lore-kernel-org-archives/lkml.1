Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbZLMWgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbZLMWgc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 17:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbZLMWga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 17:36:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbZLMWga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 17:36:30 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.DEB.2.00.0912132013050.26173@ayla.of.borg>
References: <alpine.DEB.2.00.0912132013050.26173@ayla.of.borg>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: dhowells@redhat.com, James Morris <jmorris@namei.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Mike Frysinger <vapier@gentoo.org>, Chris Zankel <chris@zankel.net>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Keys: KEYCTL_SESSION_TO_PARENT needs TIF_NOTIFY_RESUME architecture support
Date: Sun, 13 Dec 2009 22:36:16 +0000
Message-ID: <21796.1260743776@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> +#warning TIF_NOTIFY_RESUME not implemented
> +	return -EOPNOTSUPP;

I wonder if it should printk() too.

David
