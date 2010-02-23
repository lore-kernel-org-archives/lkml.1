Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab0BWPIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 10:08:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab0BWPH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 10:07:59 -0500
Date: Tue, 23 Feb 2010 10:07:41 -0500
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       aris@redhat.com
Subject: Re: [PATCH] nmi_watchdog: checkpatch.pl cleanups from earlier patches
Message-ID: <20100223150741.GA15792@redhat.com>
References: <1266880143-24943-1-git-send-email-dzickus@redhat.com>
 <20100222232427.GB20084@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100222232427.GB20084@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 02:24:27AM +0300, Cyrill Gorcunov wrote:
> On Mon, Feb 22, 2010 at 06:09:03PM -0500, Don Zickus wrote:
> ...
> 
> Hi Don!
> 
> > diff --git a/kernel/nmi_watchdog.c b/kernel/nmi_watchdog.c
> > index 3c75cbf..0a6f57f 100644
> > --- a/kernel/nmi_watchdog.c
> > +++ b/kernel/nmi_watchdog.c
> > @@ -50,31 +50,31 @@ void touch_all_nmi_watchdog(void)
> >  
> >  static int __init setup_nmi_watchdog(char *str)
> >  {
> > -        if (!strncmp(str, "panic", 5)) {
> > -                panic_on_timeout = 1;
> > -                str = strchr(str, ',');
> > -                if (!str)
> > -                        return 1;
> > -                ++str;
> > -        }
> > -        return 1;
> > +	if (!strncmp(str, "panic", 5)) {
> > +		panic_on_timeout = 1;
> 
> If I understand all the things correct -- you don't need to check for ','
> after panic. It seems so. Because we're switching to perf_events I suppose
> we may drop expecting "lapic,ioapic" or whatever here? Or there is an idea

ah good point.  I was just cutting and pasting things and didn't think to
much about it.

> to parse say "panic,software" (ie to switch to software events by default)?

interesting idea, could be useful.

Thanks,
Don
