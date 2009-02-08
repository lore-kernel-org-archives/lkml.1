Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbZBHTwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbZBHTwP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 14:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbZBHTv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 14:51:59 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:53453 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbZBHTv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 14:51:58 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sun, 8 Feb 2009 11:51:56 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Jonathan Corbet <corbet@lwn.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, David Miller <davem@davemloft.net>,
       Christoph Hellwig <hch@lst.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 1/4] Rename struct file->f_ep_lock
In-Reply-To: <1234037217-16124-2-git-send-email-corbet@lwn.net>
Message-ID: <alpine.DEB.1.10.0902081150450.18839@alien.or.mcafeemobile.com>
References: <1234037217-16124-1-git-send-email-corbet@lwn.net> <1234037217-16124-2-git-send-email-corbet@lwn.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Feb 2009, Jonathan Corbet wrote:

> This lock moves out of the CONFIG_EPOLL ifdef and becomes f_lock.  For now,
> epoll remains the only user, but a future patch will use it to protect
> f_flags as well.

Looks OK to me.


- Davide


