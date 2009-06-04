Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbZFDIgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbZFDIgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbZFDIgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:36:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751825AbZFDIgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:36:23 -0400
Date: Thu, 4 Jun 2009 01:36:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio sysfs: add a "toggle" value
Message-Id: <20090604013619.77deaefc.akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0906040116v659d0cdetaff267f4241be175@mail.gmail.com>
References: <1244017019-28163-1-git-send-email-vapier@gentoo.org>
	<20090604005435.d3671419.akpm@linux-foundation.org>
	<8bd0f97a0906040116v659d0cdetaff267f4241be175@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009 04:16:14 -0400 Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Thu, Jun 4, 2009 at 03:54, Andrew Morton wrote:
> > On Wed, __3 Jun 2009 04:16:59 -0400 Mike Frysinger wrote:
> >> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> >
> > -ENOCHANGELOGAGAIN
> 
> it's pretty damned self explanatory

The implementation is simple, but the implementation doesn't tell us why
you believe this feature should be added to Linux.

Is it because doing it from userspace is too slow?

It is because doing it from userspace is racy?  If so, isn't that
userspace already busted?

Isn't a userspace driver which doesn't already know the state of its
GPIO bits rather lame?

etc.


