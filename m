Return-Path: <linux-kernel-owner+w=401wt.eu-S933185AbXCVPal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185AbXCVPal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 11:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933228AbXCVPal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 11:30:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:40594 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933217AbXCVPak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 11:30:40 -0400
Date: Thu, 22 Mar 2007 08:28:42 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Maxim <maximlevitsky@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: sysfs ugly timer interface (was Re: [BUG] 2.6.21-rc1,2,3 regressions on my system that I found so far)
Message-ID: <20070322152842.GA6054@kroah.com>
References: <200703161230.03712.maximlevitsky@gmail.com> <200703161919.44458.lenb@kernel.org> <200703180100.01889.maximlevitsky@gmail.com> <20070320115403.GA3983@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070320115403.GA3983@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 11:54:03AM +0000, Pavel Machek wrote:
> Hi!
> 
> > root@MAIN:/home/maxim# cat /sys/devices/system/clockevents/clockevents0/registered
> > lapic                F:0007 M:3(periodic) C: 1
> > hpet                 F:0003 M:1(shutdown) C: 0
> > lapic                F:0007 M:3(periodic) C: 0
> > root@MAIN:/home/maxim#   
> 
> Now... this file needs to die, before 2.6.21 is released. It tries to
> bring /proc-like parsing nightmare to sysfs. Kill it before it becomes
> part of stable ABI!

Eeek!

I agree, that needs to be fixed now.

Remember, 1 value per file in sysfs!  Shall I just submit a patch
ripping it out for now?

thanks,

greg k-h
