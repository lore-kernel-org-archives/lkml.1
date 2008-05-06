Return-Path: <linux-kernel-owner+w=401wt.eu-S933841AbYEFWNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933841AbYEFWNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 18:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761172AbYEFWMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 18:12:41 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35103 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933616AbYEFWMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 18:12:35 -0400
Subject: Re: [PATCH 08/18] flag parameters: epoll_create
From: Matthew Helsley <matthltc@us.ibm.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, davidel@xmailserver.org,
       mtk.manpages@gmail.com, torvalds@linux-foundation.org
In-Reply-To: <200805050342.m453gk49029835@devserv.devel.redhat.com>
References: <200805050342.m453gk49029835@devserv.devel.redhat.com>
Content-Type: text/plain
Date: Tue, 06 May 2008 14:06:29 -0700
Message-Id: <1210107990.7323.347.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-05-04 at 23:42 -0400, Ulrich Drepper wrote:
> This patch adds the new epoll_create2 syscall.  It extends the old epoll_create
> syscall by one parameter which is meant to hold a flag value.  In this
> patch the only flag support is EPOLL_CLOEXEC which causes the close-on-exec
> flag for the returned file descriptor to be set.

Davide, Ulrich,

	A minor question: Why did you choose to pass the seemingly useless
"size" parameter into the new epoll_create2 system call? I did some
googling for previous threads with this series and couldn't find a
discussion on why you chose to keep it.

Cheers,
	-Matt Helsley

