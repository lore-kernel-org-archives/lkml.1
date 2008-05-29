Return-Path: <linux-kernel-owner+w=401wt.eu-S1758458AbYE2Rqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbYE2Rqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 13:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbYE2Rq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 13:46:26 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59731 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754212AbYE2RqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 13:46:24 -0400
X-Sasl-enc: DiqKLJeJU2YVtuEWA269CviABgtbvhG2c/zDynclQHRa 1212083182
Date: Thu, 29 May 2008 14:46:21 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH 15/15] rfkill: document rw rfkill switches and clarify
	input subsystem interactions (v2)
Message-ID: <20080529174620.GD3375@khazad-dum.debian.net>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <200805291919.04384.IvDoorn@gmail.com> <20080529172252.GB3375@khazad-dum.debian.net> <200805291940.09563.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805291940.09563.IvDoorn@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, Ivo van Doorn wrote:
> On Thursday 29 May 2008, Henrique de Moraes Holschuh wrote:
> > On Thu, 29 May 2008, Ivo van Doorn wrote:
> > > On Thursday 29 May 2008, Henrique de Moraes Holschuh wrote:
> > > > On Thu, 29 May 2008, Ivo van Doorn wrote:
> > > > > > This version better documents *_RFKILL_ALL.  Is it good enough for an
> > > > > > ACK for patch 14 of 15?
> > > > > 
> > > > > Yes, you can put my ack on patch 14.
> > > > > Thanks for the documentation update. :)
> > > > 
> > > > Then, this entire batch is ready for merging.  Now, if only Len would
> > > > come back from wherever he disappeared to, in order to merge the two
> > > > thinkpad-acpi patches, I could send it to netdev for merge.
> > > 
> > > Actually,  I believe the correct merge order would through wireless-dev,
> > > which means the patches should go to John Linville and linux-wireless in the CC.
> > 
> > Noted.  At merge time (which will be as soon as the thinkpad-acpi
> > changes hit mainline), I will send them to you, John, and
> > linux-wireless.
> > 
> > Unless you want me to send them all right now to linux-wireless to see
> > if there are any comments?
> 
> Well why wait with merging it into wireless-dev until thinkpad-acpi is merged?
> I don't think there are real dependencies other then the SW_RFKILL_ALL define.
> Perhaps you could send the rfkill patches with SW_RADIO instead of SW_RFKILL_ALL
> and make the rename after the thinkpad and rfkill series have both been merged.
> That would probably be the fastest route for this patch series.

Yeah, but it would be bad for the documentation, and SW_RADIO was
renamed because it was an error-inducer, so I *really* don't want to
attract any more eyes to rfkill WITHOUT getting that error-inducing
define renamed first.

OTOH, I don't want the clashes thinkpad-acpi init changes to cause a
mess for whomever is going to merge rfkill, as even if I submit them
now, the rfkill changes are next- material, while the thinkpad-acpi
changes are merge-them-ASAP material.

I will talk to Andrew Morton and see if he accepts to push the two
thinkpad-acpi changes to Linus ASAP.  Or maybe we will luck out and Len
will show up in 72h, I think he is bound to come back really soon now.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
