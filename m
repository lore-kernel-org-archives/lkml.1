Return-Path: <linux-kernel-owner+w=401wt.eu-S933904AbZJMP5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933904AbZJMP5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760282AbZJMP5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:57:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:1259 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbZJMP5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:57:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=P0gjpuRFWws8xuXvidn5jK7wicxC7k8Bj2ton0aOUHKQwzVHQn6DEVHwu+bjsPQ4Xp
         PD9/G6v6emvNjJwmN9+M9AK2rmDYBXpAVHxSBx0xz61pFo4I97Az1mrvuY+q7MTG5ave
         z7brbWznx6NKwfnQfZhmidpFj0L84oJNDLmiM=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug #14264] ehci problem - mouse dead on scroll
Date: Tue, 13 Oct 2009 17:55:20 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31.1r4; KDE/4.3.2; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>
References: <Pine.LNX.4.44L0.0910131132150.3169-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0910131132150.3169-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910131755.20166.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dienstag 13 Oktober 2009, Alan Stern wrote:
> On Mon, 12 Oct 2009, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.30 and 2.6.31.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14264
> > Subject		: ehci problem - mouse dead on scroll
> > Submitter	: Volker Armin Hemmann <volkerarmin@googlemail.com>
> > Date		: 2009-09-12 7:46 (30 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125274202707893&w=4
> > Handled-By	: Alan Stern <stern@rowland.harvard.edu>
> 
> This is probably a hardware problem in the mouse or the Logitech
> receiver.  It affected both EHCI and OHCI, and it was not reproducible
> with a different mouse.  But Volker hasn't reported any results since
> the end of September.
> 
> Volker, another good test would be to try plugging your mouse into
> someone else's computer.
> 
> Alan Stern
> 

yeah, that is a problem - I am pretty 'alone' in regard of linux users. I know 
very few, and they have either only servers without X or run some stable 
distributions with old kernels.

It is probably hardware related. I have tried two other mice and both were ok. 
Both had a lesser resolution and were slower, but that shouldn't make any 
difference.

I wanted to try some of the 32-rcs to see if they make any difference but the 
reiser4 for 2.6.31 patch does not result in a buildable kernel anymore, thanks 
to changes in writeback.h. So all I can say is:
2.6.31 is ok with the logitech, using ehci+hub+Translator settings and that is 
good enough for me.
every other mouse is ok with either ohci or attached to the hub.
