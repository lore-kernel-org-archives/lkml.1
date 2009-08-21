Return-Path: <linux-kernel-owner+w=401wt.eu-S1751984AbZHUEv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbZHUEv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 00:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbZHUEv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 00:51:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751136AbZHUEv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 00:51:57 -0400
Date: Thu, 20 Aug 2009 21:50:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 7/8] Adds functionality to read/write lock CLONE_THREAD
 fork()ing per-threadgroup
Message-Id: <20090820215007.0e774abb.akpm@linux-foundation.org>
In-Reply-To: <20090821042403.GA25865@andrew.cmu.edu>
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com>
	<20090818235843.22531.57310.stgit@menage.mtv.corp.google.com>
	<4A8CB750.7040509@cn.fujitsu.com>
	<6599ad830908191945k7c5f86b6j3ea4194f0dffa9ce@mail.gmail.com>
	<20090820141356.1bec84ed.akpm@linux-foundation.org>
	<20090821042403.GA25865@andrew.cmu.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Aug 2009 00:24:03 -0400 Ben Blum <bblum@andrew.cmu.edu> wrote:

> On Thu, Aug 20, 2009 at 02:13:56PM -0700, Andrew Morton wrote:
> > On Wed, 19 Aug 2009 19:45:11 -0700
> > Paul Menage <menage@google.com> wrote:
> > 
> > > On Wed, Aug 19, 2009 at 7:39 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
> > > >
> > > >> + __ __ __ __ __ __ list_for_each_entry_rcu(p, &tsk->thread_group, thread_group) {
> > > >> + __ __ __ __ __ __ __ __ __ __ if (p->sighand) {
> > > >> + __ __ __ __ __ __ __ __ __ __ __ __ __ __ sighand = tsk->sighand;
> > 
> > (^^ who did that?)
> > 
> 
> The tsk->sighand? Likely me. I'm surprised it took that many pairs of eyes
> to catch it.

I was actually referring to the non-ascii crap in the email.

'twas Paul.
