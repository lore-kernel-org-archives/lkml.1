Return-Path: <linux-kernel-owner+w=401wt.eu-S1762834AbXGWGmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762834AbXGWGmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbXGWGmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:42:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33591 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753872AbXGWGmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:42:35 -0400
Date: Sun, 22 Jul 2007 23:42:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>,
       lkml <linux-kernel@vger.kernel.org>,
       Linux Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, drepper@redhat.com,
       stable@kernel.org
Subject: Re: Problems with timerfd()
Message-Id: <20070722234204.10d0f9a9.akpm@linux-foundation.org>
In-Reply-To: <20070722233826.20efa6e5.akpm@linux-foundation.org>
References: <46A44B7D.3030700@gmx.net>
	<20070722233826.20efa6e5.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jul 2007 23:38:26 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> > Davide has already submitted a patch to you to make read() from a timerfd
> > file descriptor return an 8 byte integer, and I understand it to have been
> > accepted into -mm.
> 
> argh.  Nobody told me it was an ABI change!  We'll need to consider merging
> make-timerfd-return-a-u64-and-fix-the-__put_user.patch into 2.6.22.x as
> well.
> 

So I'm trying to write a halfway respectable description of that patch and
I'm stuck when it comes to describing what will happen if someone tries
to run a future timerfd-enabled glibc on 2.2.22 base.   In what manner
will it misbehave?  What are the consequences of this decision?
