Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbYCXXJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbYCXXJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 19:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbYCXXJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 19:09:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753110AbYCXXJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 19:09:44 -0400
Date: Mon, 24 Mar 2008 16:08:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: ebiederm@xmission.com, xemul@openvz.org, pavel@ucw.cz, sds@tycho.nsa.gov,
       roland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: it is fun to strace /sbin/init
Message-Id: <20080324160819.cea2d921.akpm@linux-foundation.org>
In-Reply-To: <20080324225611.GA157@tv-sign.ru>
References: <20080323135110.GA294@tv-sign.ru>
	<20080324152906.dee7b272.akpm@linux-foundation.org>
	<20080324225611.GA157@tv-sign.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008 01:56:11 +0300
Oleg Nesterov <oleg@tv-sign.ru> wrote:

> On 03/24, Andrew Morton wrote:
> >
> > On Sun, 23 Mar 2008 16:51:10 +0300
> > Oleg Nesterov <oleg@tv-sign.ru> wrote:
> > 
> > > Ptracing of /sbin/init is not allowed. Of course, this is dangerous, but may
> > > be useful. Introduce the kernel boot parameter to allow this, so that we can't
> > > surprise some special/secured systems.
> > 
> > I dunno, is this really needed?
> 
> Well, this is the question. I think it would be very nice to have the ability
> to debug/strace init. Especially if you try to make your own distribution /
> your own init.
> 
> Sometimes I see init at the top of the top's output, with this patch I have a
> chance to see what's going on on my system.

I agree that init should be ptraceable.  I'm questioning the value of a
knob which enables that ability.

Why not just unconditionally enable root's abiltiy to ptrace init?
