Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbYDMSTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbYDMSTF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 14:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbYDMSRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 14:17:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753954AbYDMSRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 14:17:16 -0400
Date: Sun, 13 Apr 2008 11:16:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: [PATCH 1/2] fix sys_unshare()+SEM_UNDO: add support for
 CLONE_SYSVSEM
Message-Id: <20080413111618.eeafc768.akpm@linux-foundation.org>
In-Reply-To: <4801F038.8020003@colorfullife.com>
References: <200804130848.m3D8mU7D007104@mail.q-ag.de>
	<20080413015936.580bf7fe.akpm@linux-foundation.org>
	<4801F038.8020003@colorfullife.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008 13:36:24 +0200 Manfred Spraul <manfred@colorfullife.com> wrote:

> >> +	if (unshare_flags & CLONE_SYSVSEM) {
> >> +		*new_ulistp = (void*)1;
> >> +	}
> >>     
> >
> > And can we do anything nicer than this?
> >
> >   
> Attached is an alternative. If you prefer it, I'll send another patch set.

Well I suppose we can fiddle with this sort of thing later.  Right now the
major concern is the testedness and reviewedness of these changes?
