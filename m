Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbXDIDFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbXDIDFJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 23:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbXDIDFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 23:05:09 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53532 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbXDIDFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 23:05:07 -0400
Date: Mon, 9 Apr 2007 08:34:59 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, akpm@linux-foundation.org,
       paulmck@us.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>, mingo@elte.hu, dipankar@in.ibm.com,
       dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 1/8] Enhance process freezer interface for usage beyond software suspend
Message-ID: <20070409030459.GC30109@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070402053457.GA9076@in.ibm.com> <20070402053705.GA12962@in.ibm.com> <20070402135632.GC6739@ucw.cz> <200704022248.25948.rjw@sisk.pl> <20070402205127.GF3840@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402205127.GF3840@elf.ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 10:51:27PM +0200, Pavel Machek wrote:
> > > 
> > > Should we create CONFIG_FREEZER?
> > 
> > Why do you think so?  I think the freezer should be compiled automatically
> > if any of the above is set, which is what this directive really means.
> 
> Kconfig can do that. ("select statement"). If we have one such ifdef,
> it is okay, but if it would be more of them.
> 

Ok.

> > > Eh? Why does kprobes code depend on config_pm?
> > 
> > Because it uses the freezer? ;-)
> 
> That is no longer true after this patch... Ugly ifdef above makes sure
> freezer is there for kprobes. I'm trying to say that #if above is
> now broken. Actually it was probably always broken, but it just became
> more so.

I have already removed it from in my version 3.

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
