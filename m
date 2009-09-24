Return-Path: <linux-kernel-owner+w=401wt.eu-S1752878AbZIXXqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbZIXXqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 19:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZIXXqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 19:46:34 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:58440 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbZIXXqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 19:46:33 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 24 Sep 2009 16:46:20 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Carlo Marcelo Arenas Belon <carenas@sajinet.com.pe>
cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] EPOLL_CTL_SET operatin for epoll_ctl when using
 EPOLLONESHOT
In-Reply-To: <1253831539-4506-1-git-send-email-carenas@sajinet.com.pe>
Message-ID: <alpine.DEB.2.00.0909241641100.1164@makko.or.mcafeemobile.com>
References: <1253831539-4506-1-git-send-email-carenas@sajinet.com.pe>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009, Carlo Marcelo Arenas Belon wrote:

> Simplify userspace by eliminating the need to track whether a specific
> filehandle was added to epoll already and only needs to be re-arm
> after being internally disabled by EPOLLONESHOT.
> 
> EPOLL_CLT_SET can be used to add or modify a filehandle in epoll
> using the kernel's internal tracking to apply the right equivalent
> operation to EPOLL_CTL_ADD or EPOLL_CTL_MOD.

Applications (except poorly written ones) usually know what's in the 
epoll set and what's not, in their bookkeeping.
I'm sorry, but I see no use of this code.



- Davide


