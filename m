Return-Path: <linux-kernel-owner+w=401wt.eu-S1759708AbXERVaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708AbXERVaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 17:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbXERVaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 17:30:07 -0400
Received: from quechua.inka.de ([193.197.184.2]:59089 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbXERVaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 17:30:06 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: aio is unlikely
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <058f01c7998e$1406e370$650df7cd@MUMBA>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1HpA1U-0002jQ-00@calista.eckenfels.net>
Date: Fri, 18 May 2007 23:30:04 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <058f01c7998e$1406e370$650df7cd@MUMBA> you wrote:
>> -#define in_aio() !is_sync_wait(current->io_wait)
>> +#define in_aio() (unlikely(!is_sync_wait(current->io_wait)))
> 
> Shouldn't unlikely() go where in_aio() is actually used, if we printk(error)
> there?

Actually I would just remove that define and use the method directly, if
this is the only place where it is used. If it is used in multiple places,
the unlikely is most likely wrong .)

Gruss
Bernd
