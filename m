Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab0APP56 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 10:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753542Ab0APP5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 10:57:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754543Ab0APP5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 10:57:52 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1261413866-30634-1-git-send-email-vapier@gentoo.org>
References: <1261413866-30634-1-git-send-email-vapier@gentoo.org> <8bd0f97a0910052125m4327fef3i47e3b549938802f9@mail.gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: dhowells@redhat.com, uclinux-dev@uclinux.org,
        David McCullough <davidm@snapgear.com>,
        Greg Ungerer <gerg@uclinux.org>, Paul Mundt <lethal@linux-sh.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nommu: implement vmap/vunmap with kmalloc
Date: Sat, 16 Jan 2010 15:57:24 +0000
Message-ID: <31911.1263657444@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Seems a reasonable idea.

It could be done more efficiently if vunmap() was given the page count given
to vmap().

David
