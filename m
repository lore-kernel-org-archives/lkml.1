Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbZEUJjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbZEUJjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 05:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbZEUJjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 05:39:08 -0400
Received: from mx.sz.bfs.de ([194.94.69.70]:48933 "EHLO mx.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbZEUJjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 05:39:07 -0400
X-Greylist: delayed 1756 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 May 2009 05:39:07 EDT
Message-ID: <4A151A40.1020901@bfs.de>
Date: Thu, 21 May 2009 11:09:20 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: michael@ellerman.id.au
Cc: Chris Sanford <crsanford@gmail.com>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH] include KERN_* constant in printk calls
References: <20090518233121.GC3109@chrisubuntu-laptop>	 <20090519090049.GB9388@elte.hu> <20090520043215.GA3077@chrisubuntu-laptop>	 <20090520083719.GG6736@elte.hu>  <20090521024635.GA4030@chrisubuntu-laptop> <1242882592.4784.44.camel@concordia>
In-Reply-To: <1242882592.4784.44.camel@concordia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Michael Ellerman schrieb:
> On Wed, 2009-05-20 at 19:46 -0700, Chris Sanford wrote:
>> Here is the updated patch for sched.c. It replaces all the printk calls with their
>> corresponding pr_* call. The five KERN_DEBUG calls have been changed to
>> pr_info.
> 
> Switching from KERN_DEBUG to KERN_INFO means the messages will now
> appear for most people, whereas previously they didn't. I'm not sure
> that's a great idea.
> 
> If you really want to convert them, then I think we need a macro for
> KERN_DEBUG but not conditionally compiled like pr_debug.
> 
> I sent a patch for that once, but I don't think anyone liked it, and
> I've lost it now :D
> 

beeing mainly a user theses days i would like to comment ...

It is fine if debug statements are disabled within NO_DEBUG mode.
As user i find them annoying because i do not care.
KERN_INFO is ok and if people complain they need more info someone
can always change from DEBUG to INFO.
putting to much info into syslog simply drowns important informations.
so keep it as pr_debug().

just my 2 cents,
 wh

