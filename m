Return-Path: <linux-kernel-owner+w=401wt.eu-S1757294AbYFELeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbYFELeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 07:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbYFELdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 07:33:51 -0400
Received: from mail37.messagelabs.com ([216.82.244.163]:32974 "EHLO
	mail37.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbYFELdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 07:33:50 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-14.tower-37.messagelabs.com!1212665628!1604286!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Thu, 5 Jun 2008 13:33:41 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Magnus Damm <magnus.damm@gmail.com>
CC: "Hans J. Koch" <hjk@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] uio_pdrv: Unique IRQ Mode
Message-ID: <20080605113341.GA23296@digi.com>
References: <20080604060826.17162.46972.sendpatchset@rx1.opensource.se> <20080604101144.GA3207@local> <aec7e5c30806041825o4c6c859fp8380063e9384622@mail.gmail.com> <20080605090916.GA3198@local> <aec7e5c30806050246t248abc39vbc1e71d4475a0a0d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aec7e5c30806050246t248abc39vbc1e71d4475a0a0d@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 05 Jun 2008 11:33:44.0454 (UTC) FILETIME=[03036260:01C8C700]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Magnus,

Magnus Damm wrote:
> >> I don't think the board support level is the
> >> proper place for this code.
> >
> > You have to write code there anyway, e.g. code that configures your GPIO
> > as input, makes it generate interrupts and so on. And of course, you
> > have to setup your platform device as well. If you simply add the irq
> > handler, you can use uio_pdrv as-is. And if you _know_ that on your
> > platform the irq is not shared, this might really be a one-liner that
> > simply calls irq_disable. That's OK in board specific code, but not in a
> > generic driver.
> 
> Ever heard about system on chip? Not all platform devices need board
> specific setup.
> 
> >> The patch contains no board specific code,
> >> and it is independent of both architecture and cpu model.
> >
> > Every platform device driver depends on board support.
> 
> Is that so?
This depends on the definition of "board support".  I think of it as
"code for that (type of) machine", i.e. everything below arch/.  With
that definition really each platform device depends on "board support"
because some code have to create and provide the platform_device.

>             I suggest that you have a look at the mfd drivers and think again.
I haven't done that though.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
