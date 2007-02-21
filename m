Return-Path: <linux-kernel-owner+w=401wt.eu-S1422641AbXBUPi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422641AbXBUPi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 10:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422640AbXBUPiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 10:38:54 -0500
Received: from wr-out-0506.google.com ([64.233.184.232]:41201 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422632AbXBUPil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 10:38:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=o3rWKvsg/pyC1fEfxQYIcoLA+gXfgFNah1vzEcy9y63wUuQ88Y2rtxrwPvEDzRx1iLyBErvRJAvaYS+Vy7fQNXCRRx9zQXa0LW9wXhN0K+tBbexQyvNhZdAFOGYvXLJ+hyIeef3IeYmq3/ltAv6RDmhqJXPbqSrvzzLHdSoT1nA=
Message-ID: <6bffcb0e0702210738p687ca1bdt2c568d7ed5904fff@mail.gmail.com>
Date: Wed, 21 Feb 2007 16:38:39 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: tglx@linutronix.de
Subject: Re: 2.6.20-git15 BUG: soft lockup detected on CPU#0! - timers?
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1172072023.25076.64.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6bffcb0e0702201054rb839bb2m11ef8d33bacffdb8@mail.gmail.com>
	 <1172008584.25076.0.camel@localhost.localdomain>
	 <6bffcb0e0702201437o66db38d5j3066eb3c9951a270@mail.gmail.com>
	 <1172072023.25076.64.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/02/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 2007-02-20 at 23:37 +0100, Michal Piotrowski wrote:
> > On 20/02/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> > > On Tue, 2007-02-20 at 19:54 +0100, Michal Piotrowski wrote:
> > > >
> > > > Might it be 6ba9b346e1e0eca65ec589d32de3a9fe32dc5de6 commit?
> > >
> > > I doubt that it is, but can you revert it ?
> >
> > I'm using the latest kernel without this patch since 3 hours.
> >
> > So far so good.
>
> But you still have those softirq pending messages, right ?

Yes

(+ new NOHZ: local_softirq_pending 02)
http://www.ussg.iu.edu/hypermail/linux/kernel/0702.2/1944.html

> I think those
> are pointing to the root cause of this. Still no idea how to get hold of
> them. All my systems refuse to produce that. Hrmpf.
>
>         tglx
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
