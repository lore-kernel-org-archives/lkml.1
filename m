Return-Path: <linux-kernel-owner+w=401wt.eu-S1761548AbZANKZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761548AbZANKZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbZANKZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:25:41 -0500
Received: from krynn.se.axis.com ([193.13.178.10]:37456 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbZANKZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:25:37 -0500
Date: Wed, 14 Jan 2009 11:25:00 +0100
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Greg KH <gregkh@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Miller <davem@davemloft.net>, "tj@kernel.org" <tj@kernel.org>,
       "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "hinko.kocevar@cetrtapot.si" <hinko.kocevar@cetrtapot.si>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: lib/klist.c: bit 0 in pointer can't be used as flag
Message-ID: <20090114102500.GG19262@axis.com>
References: <2f11576a0901131440w7fd3290uc9664aaf7aa89b08@mail.gmail.com> <20090113.144521.97357573.davem@davemloft.net> <20090114085341.442C.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090113235914.GA20727@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113235914.GA20727@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 12:59:14AM +0100, Greg KH wrote:
> So, is this change still needed for klists?  I'm guessing so as they
> could be in statically allocated objects, right?

Like I said in another email, we can get away with just making
the struct klist aligned to 4 bytes (or 2 would probably suffice).
It would be a less intrusive patch.

> Here's yet another reason to never statically allocate a kobject...
> 
> thanks,
> 
> greg k-h

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
