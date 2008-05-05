Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbYEEEvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbYEEEvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 00:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYEEEuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 00:50:55 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51637 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbYEEEuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 00:50:54 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 4 May 2008 21:50:52 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mtk.manpages@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 07/18] flag parameters: timerfd_create
In-Reply-To: <200805050342.m453gkOX029832@devserv.devel.redhat.com>
Message-ID: <Pine.LNX.4.64.0805042150340.8307@alien.or.mcafeemobile.com>
References: <200805050342.m453gkOX029832@devserv.devel.redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 May 2008, Ulrich Drepper wrote:

> The timerfd_create syscall already has a flags parameter.  It just is
> unused so far.  This patch changes this by introducing the TFD_CLOEXEC
> flag to set the close-on-exec flag for the returned file descriptor.
> 
> A new flag TFD_CLOEXEC is used instead of reusing O_CLOEXEC to prevent
> exhaustion of the int bit field in case we need more flags.
> 
> The following test must be adjusted for architectures other than x86 and
> x86-64 and in case the syscall numbers changed.

> Signed-off-by: Ulrich Drepper <drepper@redhat.com>

Acked-by: Davide Libenzi <davidel@xmailserver.org>



- Davide


