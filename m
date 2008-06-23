Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbYFWVxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbYFWVxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 17:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbYFWVx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 17:53:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36742 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753337AbYFWVxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 17:53:25 -0400
Date: Mon, 23 Jun 2008 14:52:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: oleg@tv-sign.ru, ebiederm@xmission.com, mingo@elte.hu,
       torvalds@linux-foundation.org, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] introduce PF_KTHREAD flag
Message-Id: <20080623145212.c6627156.akpm@linux-foundation.org>
In-Reply-To: <200806232336.59965.rjw@sisk.pl>
References: <20080601153042.GA8238@tv-sign.ru>
	<20080623134706.f5e1ef32.akpm@linux-foundation.org>
	<20080623135253.ed7cabf1.akpm@linux-foundation.org>
	<200806232336.59965.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008 23:36:59 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday, 23 of June 2008, Andrew Morton wrote:
> > On Mon, 23 Jun 2008 13:47:06 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > I don't yet know how much additional damage will happen as a result.
> > 
> > Lots.
> 
> Well, sorry about that.  I can ask Len to drop the freezer patch temporarily
> and rebase it on top of -next if that helps.

The freezer patch is already in linux-next.  Assuming those changes are
planned for 2.6.27 then it's best to leave things as they are.


Some of these problems will go away once I get most-of-mm into
linux-next.  But it will mean that people will need to start weaning
themselves off the practice of preparing patches against Linus
mainline.

