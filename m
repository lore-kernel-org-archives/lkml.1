Return-Path: <linux-kernel-owner+w=401wt.eu-S1757501AbZINW7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbZINW7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 18:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932550AbZINW7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 18:59:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757491AbZINW7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 18:59:33 -0400
Date: Tue, 15 Sep 2009 00:59:28 +0200
From: Karel Zak <kzak@redhat.com>
To: rtc-linux@googlegroups.com
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: [PATCH 2/2] rtc: Add boot_timesource sysfs
	attribute
Message-ID: <20090914225928.GB29406@nb.net.home>
References: <1252081568-6000-1-git-send-email-mjg@redhat.com> <1252081568-6000-2-git-send-email-mjg@redhat.com> <20090904182528.591dbd29@i1501.lan.towertech.it> <20090904163029.GA25239@srcf.ucam.org> <20090904183828.4376236e@i1501.lan.towertech.it> <20090904164127.GB25419@srcf.ucam.org> <20090904185243.53c9b440@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904185243.53c9b440@i1501.lan.towertech.it>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 06:52:43PM +0200, Alessandro Zummo wrote:
> 
> On Fri, 4 Sep 2009 17:41:27 +0100
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> 
> > >  it shouldn't. maybe your hwclock is waiting for the tick
> > >  or something similar. I'd check it.  
> > 
> > I'm just going by what our userspace people are saying. They'd prefer 
> > not to have to run --hctosys if the time's already been set - 
> > https://bugzilla.redhat.com/show_bug.cgi?id=489494 has the discussion.
> > 
> 
>  that's ok, but nonetheless there's a problem in hwclock
>  if it takes 3 secs to read the time.

 IMHO 3 seconds is nonsense. It's usually 0.5 - 1 second.
 
 Anyway, the "hwclock --hctosys" in userspace is a mystical voodoo and
 it's definitely better to move this thing to kernel.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
