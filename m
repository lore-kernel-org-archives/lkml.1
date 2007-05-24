Return-Path: <linux-kernel-owner+w=401wt.eu-S1751216AbXEXQOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbXEXQOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 12:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbXEXQOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 12:14:32 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:35692 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbXEXQOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 12:14:31 -0400
Date: Thu, 24 May 2007 18:13:17 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] add "notime" boot option
In-Reply-To: <20070522120938.db67f1e9.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.61.0705241812450.31549@yvahk01.tjqt.qr>
References: <20070522120938.db67f1e9.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 22 2007 12:09, Randy Dunlap wrote:
>From: Randy Dunlap <randy.dunlap@oracle.com>
>
>Add "notime" boot option to prevent timing data from being printed on
>each printk message line.
>
>We've seen a few cases of 'time' data locking problems (possibly
>involving netconsole or net drivers).  If a kernel is built with
>CONFIG_PRINTK_TIME=y, it may have a boot locking hang.  Booting
>with "notime" may (i.e., could) prevent the lock hang and allow the
>kernel to boot successfully, without requiring a kernel rebuild.

Wonderful, now we have _three_ options to control time...

	time=<bool>
	printk.time=<bool>
	notime=<bool>


	Jan
-- 
