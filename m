Return-Path: <linux-kernel-owner+w=401wt.eu-S1765492AbXE2UJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765492AbXE2UJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757390AbXE2UJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:09:29 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897AbXE2UJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:09:28 -0400
Date: Tue, 29 May 2007 13:07:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, rene.herman@gmail.com, mjt@tls.msk.ru,
       Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] use printk.time option, drop time/notime
Message-Id: <20070529130705.fdf43e4b.akpm@linux-foundation.org>
In-Reply-To: <20070524171535.329ea2c0.randy.dunlap@oracle.com>
References: <20070522120938.db67f1e9.randy.dunlap@oracle.com>
	<Pine.LNX.4.61.0705241812450.31549@yvahk01.tjqt.qr>
	<4655BC2D.2070701@oracle.com>
	<Pine.LNX.4.61.0705241832500.31549@yvahk01.tjqt.qr>
	<20070524171535.329ea2c0.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 17:15:35 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Allow printk_time to be enabled or disabled at boot time.
> Previously it could be enabled only, but not disabled.
> 
> Change printk_time from an int to a bool since that's what it is.
> Make its logical (exposed) name just be "time" (was "printk_time").
> 
> Note:  Changes kernel boot option syntax from "time" to "printk.time=value".

That's going to break a *lot* of people's setups - timestamping appears
to be very popular.  We will get sad emails from people.

If we're going to do this then I'm afraid we should retain the `time='
thing for a while and add a this-is-going-away printk to it.
