Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247Ab0BNAkx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 19:40:53 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:57750 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab0BNAkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 19:40:52 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 13 Feb 2010 16:40:50 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Matt Helsley <matthltc@us.ibm.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/4] Check O_* flags set with fcntl() on anon_inode
 files.
In-Reply-To: <1266107267-5920-1-git-send-email-matthltc@us.ibm.com>
Message-ID: <alpine.DEB.2.00.1002131640080.4562@makko.or.mcafeemobile.com>
References: <1266107267-5920-1-git-send-email-matthltc@us.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Feb 2010, Matt Helsley wrote:

> anon_inode interfaces often do not support flags that can be set
> by fcntl(). Right now using fcntl() to set these flags falsely
> reports success for things like O_ASYNC yet SIGIO is not delivered.
> 
> I relied on the flags allowed by the syscalls that create
> these files to determine the flags that are allowed to be set by
> fcntl().
> 
> Each patch checks flags for one anonymous inode interface:
> 
> [PATCH 1/4] signalfd
> [PATCH 2/4] timerfd
> [PATCH 3/4] epoll
> [PATCH 4/4] eventfd

The whole serie ...

Acked-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


