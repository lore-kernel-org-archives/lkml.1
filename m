Return-Path: <linux-kernel-owner+w=401wt.eu-S1761076AbXISPsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761076AbXISPsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 11:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbXISPrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 11:47:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:60595 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755724AbXISPrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 11:47:51 -0400
To: Ulrich Drepper <drepper@redhat.com>
Cc: netdev <netdev@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: follow-up: discrepancy with POSIX
References: <46F13E8B.4050309@redhat.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 19 Sep 2007 17:47:50 +0200
In-Reply-To: <46F13E8B.4050309@redhat.com>
Message-ID: <p73sl5aveqh.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper <drepper@redhat.com> writes:

> 
>    fd = socket(AT_INET6, ...)
> 
>    connect(fd, ...some IPv6 address...)
> 
>    struct sockaddr_in6 sin6 = { .sin6_family = AF_INET6 };
>    connect(fd, &sin6, sizeof (sin6));

The standard way to undo connect is to use AF_UNSPEC. Code to handle
that for dgram sockets is there. It's the same code for v4 and v6.

-Andi

