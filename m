Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbZFFJ7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbZFFJ7e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 05:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbZFFJ70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 05:59:26 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:37494 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbZFFJ70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 05:59:26 -0400
Date: Sat, 6 Jun 2009 11:59:26 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH -next] mmc: cb710 cleanups
Message-ID: <20090606095926.GA5455@rere.qmqm.pl>
References: <20090605164104.3cebe18d.sfr@canb.auug.org.au> <4A295DD9.2050301@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A295DD9.2050301@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jun 05, 2009 at 11:03:05AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> - don't define DEBUG, just use CONFIG_CB710_DEBUG or CONFIG_MMC_DEBUG
> - fix printk format warnings
> 
> In file included from drivers/mmc/host/cb710-mmc.h:13,
>                  from drivers/mmc/host/cb710-mmc.c:15:
> include/linux/cb710.h:14:1: warning: "DEBUG" redefined
> <command-line>: warning: this is the location of the previous definition
> 
> drivers/mmc/host/cb710-mmc.c:222: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
> drivers/mmc/host/cb710-mmc.c:222: warning: format '%d' expects type 'int', but argument 6 has type 'size_t'

Fixes for these warnings are already queued in Pierre's mailbox. 
Should I Cc: linux-next from now on since the base patch went to linux-next?

Best Regards,
Micha³ Miros³aw
