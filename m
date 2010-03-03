Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab0CCJpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 04:45:07 -0500
Received: from mailgw10.se.ericsson.net ([193.180.251.61]:47624 "EHLO
	mailgw10.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab0CCJpF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 04:45:05 -0500
X-AuditID: c1b4fb3d-b7c72ae00000040e-b4-4b8e2f9fbc67
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/5] DMAENGINE: COH 901 318 cleanups
Date: Wed, 3 Mar 2010 10:45:00 +0100
Message-ID: <A6D19A13FE030A409EC4362C172E091F0E9EE3FA@eseldmw101.eemea.ericsson.se>
In-Reply-To: <e9c3a7c21003021321h7df40afep2a3c82c6d429cf47@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/5] DMAENGINE: COH 901 318 cleanups
Thread-Index: Acq6TlvtK+1sT//FRo2sbzgHNBKicwAZ6NuQ
References: <1267560734-17001-1-git-send-email-linus.walleij@stericsson.com> <e9c3a7c21003021306w3546521dsd1ad50893f1ea44b@mail.gmail.com> <e9c3a7c21003021321h7df40afep2a3c82c6d429cf47@mail.gmail.com>
From: "Linus Walleij" <linus.walleij@stericsson.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 03 Mar 2010 09:45:03.0150 (UTC) FILETIME=[32BC5CE0:01CABAB6]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Dan Williams]
> On Tue, Mar 2, 2010 at 2:06 PM, Dan Williams 
> <dan.j.williams@intel.com> wrote:
> > On Tue, Mar 2, 2010 at 1:12 PM, Linus Walleij
> > <linus.walleij@stericsson.com> wrote:
> >>        if (cohc->nbr_active_done)
> >> +       /*
> >> +        * If another interrupt fired while the tasklet 
> was scheduling,
> >> +        * we don't get called twice, so we have this 
> number of active
> >> +        * counter that keep track of the number of IRQs 
> expected to
> >> +        * be handled for this channel. If there happen to 
> be more than
> >> +        * one IRQ to be ack:ed, we simply schedule this 
> tasklet again.
> >> +        */
> >>                cohc->nbr_active_done--;
> >
> > Checkpatch made a justifiable wimper about this.  It looks like you
> > wanted to delete that if() according to the previous unified patch?
> >
> 
> Looks like it gets deleted later on in patch #3.  I took a stab at
> fixing it up[1], or you can just send me a new series if that does not
> look right to you.

That's perfect, thanks Dan. I was splitting the patch up using
some iterative kdiff3 excercises, I just checkpatch.pl:ed the
end result, sorry.

Yours,
Linus Walleij
