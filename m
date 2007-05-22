Return-Path: <linux-kernel-owner+w=401wt.eu-S934576AbXEVOv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934576AbXEVOv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 10:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759494AbXEVOvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 10:51:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:57368 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759449AbXEVOvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 10:51:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=a8OyKx89/mBKbEHjsRhtcYA0HQ719HUhHFknVNcVqN4MpvPBQbPG2Zi48vlXF3dq+pObM7g4x8XPWpghDkj2SCxwjvF81RZ4emf1f0wDFjLmbnKfj5OHLWsIal4yKQoXpLpQ0DzCbfEaUplpODODtmNUIDRnxxlDRz6xXcV99xU=
Message-ID: <2c0942db0705220751m202c4848j2c4a34793337713a@mail.gmail.com>
Date: Tue, 22 May 2007 07:51:10 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [1/5] 2.6.22-rc2: known regressions
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Adrian McMenamin" <adrian@newgolddream.dyndns.info>,
       linux-acpi@vger.kernel.org, "Len Brown" <lenb@kernel.org>
In-Reply-To: <200705221401.41272.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464F74BB.9070402@googlemail.com>
	 <2c0942db0705211729r185d7d77r2750d82f4a3b3e9c@mail.gmail.com>
	 <200705221401.41272.rjw@sisk.pl>
X-Google-Sender-Auth: 8b8ec9cffce333c2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, 22 May 2007 02:29, Ray Lee wrote:
> > Hey there,
> >
> > On 5/19/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> > > Here is a list of some known regressions in 2.6.22-rc2.
> > >
> > > Feel free to add new regressions/remove fixed etc.
> > > http://kernelnewbies.org/known_regressions
> > >
> > > Subject    : nx6125 has lost fan control
> > > References : http://lkml.org/lkml/2007/5/16/249
> > > Submitter  : Ray Lee <ray-lk@madrabbit.org>
> > > Status     : Unknown
> >
> > I'm withdrawing this one. At boot, it wasn't controlling the fans, but
> > after a suspend-resume it started up fine. My subsequent boots have
> > also been okay, so I'm at a loss to explain what I saw.
> >
> > Regardless, given that it's hard to reproduce, I have no evidence that
> > it's a regression, it could just be something that's really rare.
>
> Such things sometimes happen on nx6325 too.  Apparently, after a reboot
> the BIOS (or rather the platform firmware) sometimes gets confused and behaves
> like this.

Okay, so I'm not crazy; good to know :-). It's not a big deal as
suspend to ram and back will clear it out.

Thanks for the insight,

Ray
