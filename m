Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbZIDQlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbZIDQlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757057AbZIDQlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:41:35 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45914 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506AbZIDQle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:41:34 -0400
Date: Fri, 4 Sep 2009 17:41:27 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: [PATCH 2/2] rtc: Add boot_timesource sysfs
	attribute
Message-ID: <20090904164127.GB25419@srcf.ucam.org>
References: <1252081568-6000-1-git-send-email-mjg@redhat.com> <1252081568-6000-2-git-send-email-mjg@redhat.com> <20090904182528.591dbd29@i1501.lan.towertech.it> <20090904163029.GA25239@srcf.ucam.org> <20090904183828.4376236e@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904183828.4376236e@i1501.lan.towertech.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 06:38:28PM +0200, Alessandro Zummo wrote:
> On Fri, 4 Sep 2009 17:30:29 +0100
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> 
> > We'd prefer to avoid always doing --hctosys because it's a 
> > noticable performance hit on boot if the work's already been done by the 
> > kernel.
> 
>  it shouldn't. maybe your hwclock is waiting for the tick
>  or something similar. I'd check it.

I'm just going by what our userspace people are saying. They'd prefer 
not to have to run --hctosys if the time's already been set - 
https://bugzilla.redhat.com/show_bug.cgi?id=489494 has the discussion.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
