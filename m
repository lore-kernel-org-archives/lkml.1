Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab0BVXcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 18:32:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:57329 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab0BVXcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 18:32:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FcJmaufvDJG6ujou6YQqpPCCEI5OtlY6n8mEjXhDL/AT+whsDbetExN62kSuIMXiSR
         71ldTFQfomXKQ9D9bJWJeXLwhxTR6Xa8h1Ev1HnqjiqqZNDycGTX1pC7R3YTdWfqPYqv
         hNyc6+CkShgnkwGYSKrQLoaGXVTAO9oCSgqh8=
Date: Tue, 23 Feb 2010 02:31:58 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, peterz@infradead.org, aris@redhat.com
Subject: Re: [PATCH] nmi_watchdog: checkpatch.pl cleanups from earlier
	patches
Message-ID: <20100222233158.GC20084@lenovo>
References: <1266880143-24943-1-git-send-email-dzickus@redhat.com> <20100222232427.GB20084@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100222232427.GB20084@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
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
> to parse say "panic,software" (ie to switch to software events by default)?
> 
> Though strictly speaking my question in rather unrelated to this patch
> agenda :)
> 
> > +		str = strchr(str, ',');
> > +		if (!str)
> > +			return 1;
> > +		++str;
> > +	}
> > +	return 1;
> >  }
> >  __setup("nmi_watchdog=", setup_nmi_watchdog);
> ...
> 
> 	-- Cyrill

If I'm right -- the fix could be done later, after this patch applied.

	-- Cyrill
