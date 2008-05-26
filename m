Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbYEZWDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbYEZWDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 18:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbYEZWDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 18:03:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbYEZWDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 18:03:25 -0400
Date: Mon, 26 May 2008 18:01:54 -0400
From: Alan Cox <alan@redhat.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Alan Cox <alan@redhat.com>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] video4linux: Push down the BKL
Message-ID: <20080526220154.GA15487@devserv.devel.redhat.com>
References: <20080522223700.2f103a14@core> <20080526135951.7989516d@gaivota> <20080526202317.GA12793@devserv.devel.redhat.com> <20080526181027.1ff9c758@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080526181027.1ff9c758@gaivota>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2008 at 06:10:27PM -0300, Mauro Carvalho Chehab wrote:
> The hardest and optimal scenario is to look inside all drivers, fix the locks
> (and pray for a further patch to not break them). I'm afraid that this is a long
> term strategy.

Ultimately that is where you end up.

> For example, a very simple scenario would simply replace BKL by one mutex.
> This way, just one ioctl could be handled at the same time. This is something

video2_ioctl_serialized() ?
