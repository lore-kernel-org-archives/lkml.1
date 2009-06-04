Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbZFDJFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbZFDJFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 05:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbZFDJFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 05:05:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750829AbZFDJFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 05:05:37 -0400
Date: Thu, 4 Jun 2009 02:05:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio sysfs: add a "toggle" value
Message-Id: <20090604020501.cdeb8f10.akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0906040152h1fa57f5crd96faa37322a1b40@mail.gmail.com>
References: <1244017019-28163-1-git-send-email-vapier@gentoo.org>
	<20090604005435.d3671419.akpm@linux-foundation.org>
	<8bd0f97a0906040116v659d0cdetaff267f4241be175@mail.gmail.com>
	<200906040127.24740.david-b@pacbell.net>
	<8bd0f97a0906040152h1fa57f5crd96faa37322a1b40@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009 04:52:35 -0400 Mike Frysinger <vapier.adi@gmail.com> wrote:

> my next request was for a 1 letter command set and chaining
> operations.  say you want to toggle a gpio line 4 times, having to go
> between kernel and userspace for that seems kind of heavy.
> echo TTTT > value

I was wondering whether "t" would be better than "toggle".

If you're going to do that, wouldn't you need a "d"(elay) too?  To
prevent large variations in interval between different platforms.  1
millisec, perhaps.

0d1dd0d1ddd0d1, too.

This could be fun.
