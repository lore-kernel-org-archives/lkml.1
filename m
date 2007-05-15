Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbXEOUtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbXEOUtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 16:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbXEOUtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 16:49:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51344 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbXEOUtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 16:49:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex Dubov <oakad@yahoo.com>
Subject: Re: Freezeable workqueues [Was: 2.6.22-rc1: Broken suspend on SMP with tifm]
Date: Tue, 15 May 2007 22:54:27 +0200
User-Agent: KMail/1.9.5
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Pierre Ossman <drzeus@drzeus.cx>, Pavel Machek <pavel@ucw.cz>,
       Gautham R Shenoy <ego@in.ibm.com>
References: <390169.9239.qm@web36708.mail.mud.yahoo.com>
In-Reply-To: <390169.9239.qm@web36708.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705152254.28911.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 15 May 2007 02:56, Alex Dubov wrote:
> > 
> > > > 	- Do we need freezeable workqueues ?
> > > 
> > > Well, we have at least one case in which they appear to be useful.
> > 
> 
> I need freezeable wq exactly for the fact that they are synchronized with suspend/resume. My
> workitem may do device_register/unregister and it can (and will be) scheduled from irq handler
> during resume. As far as I understand, before freezeable wqs, kthreads were the only way to
> achieve this behavior,

That's correct.

> which is less convenient.

Thanks for the explanation. 

Greetings,
Rafael
