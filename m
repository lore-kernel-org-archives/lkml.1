Return-Path: <linux-kernel-owner+w=401wt.eu-S1758795AbYE2S7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbYE2S7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbYE2S7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:59:03 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:2248 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbYE2S7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:59:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=PGvPwjjQ6L2d3C9f8wWykpDFW7Wcv9Q8YreZ8LzbH9mOvabUIs9wCp+TWN565kGL2vZ129gDBkWuk151Uq1zSozEY0pp0lEEC+2GcUGrqmZs99kE0qWpUNdbuOtICCrmEnvv75JO9cTiqTTEC+uxWOuEiqFHOv6UqT0LpgEK9II=
Date: Thu, 29 May 2008 14:58:54 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 15/15] rfkill: document rw rfkill switches and clarify
	input subsystem interactions (v2)
Message-ID: <20080529145256.ZZRA012@mailhub.coreip.homeip.net>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <200805291919.04384.IvDoorn@gmail.com> <20080529172252.GB3375@khazad-dum.debian.net> <200805291940.09563.IvDoorn@gmail.com> <20080529174620.GD3375@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529174620.GD3375@khazad-dum.debian.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 02:46:21PM -0300, Henrique de Moraes Holschuh wrote:
> On Thu, 29 May 2008, Ivo van Doorn wrote:
> > On Thursday 29 May 2008, Henrique de Moraes Holschuh wrote:
> > > On Thu, 29 May 2008, Ivo van Doorn wrote:
> > > > On Thursday 29 May 2008, Henrique de Moraes Holschuh wrote:
> > > > > On Thu, 29 May 2008, Ivo van Doorn wrote:
> > > > > > > This version better documents *_RFKILL_ALL.  Is it good enough for an
> > > > > > > ACK for patch 14 of 15?
> > > > > > 
> > > > > > Yes, you can put my ack on patch 14.
> > > > > > Thanks for the documentation update. :)
> > > > > 
> > > > > Then, this entire batch is ready for merging.  Now, if only Len would
> > > > > come back from wherever he disappeared to, in order to merge the two
> > > > > thinkpad-acpi patches, I could send it to netdev for merge.
> > > > 
> > > > Actually,  I believe the correct merge order would through wireless-dev,
> > > > which means the patches should go to John Linville and linux-wireless in the CC.
> > > 
> > > Noted.  At merge time (which will be as soon as the thinkpad-acpi
> > > changes hit mainline), I will send them to you, John, and
> > > linux-wireless.
> > > 
> > > Unless you want me to send them all right now to linux-wireless to see
> > > if there are any comments?
> > 
> > Well why wait with merging it into wireless-dev until thinkpad-acpi is merged?
> > I don't think there are real dependencies other then the SW_RFKILL_ALL define.
> > Perhaps you could send the rfkill patches with SW_RADIO instead of SW_RFKILL_ALL
> > and make the rename after the thinkpad and rfkill series have both been merged.
> > That would probably be the fastest route for this patch series.
> 
> Yeah, but it would be bad for the documentation, and SW_RADIO was
> renamed because it was an error-inducer, so I *really* don't want to
> attract any more eyes to rfkill WITHOUT getting that error-inducing
> define renamed first.
> 
> OTOH, I don't want the clashes thinkpad-acpi init changes to cause a
> mess for whomever is going to merge rfkill, as even if I submit them
> now, the rfkill changes are next- material, while the thinkpad-acpi
> changes are merge-them-ASAP material.
> 
> I will talk to Andrew Morton and see if he accepts to push the two
> thinkpad-acpi changes to Linus ASAP.  Or maybe we will luck out and Len
> will show up in 72h, I think he is bound to come back really soon now.
> 

I wonder why thinkpad_acpi has to go through Len, it seems to live
in drivers/misc... Does it depend on some other ACPI changes that
are not in mainline/-mm yet? If it not I'd probably bombard Andrew
with it.

Alternatively SW_RFKILL_ALL can be brought in through wireless three
or I can add it to my "for_linus" branch that I want Linus to pull
soon.

-- 
Dmitry
