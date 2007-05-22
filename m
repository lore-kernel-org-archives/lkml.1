Return-Path: <linux-kernel-owner+w=401wt.eu-S1765929AbXEVL4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765929AbXEVL4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 07:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757300AbXEVL4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 07:56:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55900 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757023AbXEVL4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 07:56:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: [1/5] 2.6.22-rc2: known regressions
Date: Tue, 22 May 2007 14:01:40 +0200
User-Agent: KMail/1.9.5
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Adrian McMenamin" <adrian@newgolddream.dyndns.info>,
       linux-acpi@vger.kernel.org, "Len Brown" <lenb@kernel.org>
References: <464F74BB.9070402@googlemail.com> <2c0942db0705211729r185d7d77r2750d82f4a3b3e9c@mail.gmail.com>
In-Reply-To: <2c0942db0705211729r185d7d77r2750d82f4a3b3e9c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705221401.41272.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 22 May 2007 02:29, Ray Lee wrote:
> Hey there,
> 
> On 5/19/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> > Here is a list of some known regressions in 2.6.22-rc2.
> >
> > Feel free to add new regressions/remove fixed etc.
> > http://kernelnewbies.org/known_regressions
> >
> > Subject    : nx6125 has lost fan control
> > References : http://lkml.org/lkml/2007/5/16/249
> > Submitter  : Ray Lee <ray-lk@madrabbit.org>
> > Status     : Unknown
> 
> I'm withdrawing this one. At boot, it wasn't controlling the fans, but
> after a suspend-resume it started up fine. My subsequent boots have
> also been okay, so I'm at a loss to explain what I saw.
> 
> Regardless, given that it's hard to reproduce, I have no evidence that
> it's a regression, it could just be something that's really rare.

Such things sometimes happen on nx6325 too.  Apparently, after a reboot
the BIOS (or rather the platform firmware) sometimes gets confused and behaves
like this.

Greetings,
Rafael
