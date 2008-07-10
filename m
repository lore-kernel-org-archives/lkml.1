Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbYGJN3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbYGJN3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 09:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755700AbYGJN3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 09:29:41 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:35247 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754222AbYGJN3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 09:29:40 -0400
X-Sasl-enc: qkSbH3I5+0b/EvNk4IYjqpjKh0rK6V+S8q3YpLxSFkcR 1215696578
Date: Thu, 10 Jul 2008 10:29:34 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       ak@linux.intel.com, Len Brown <lenb@kernel.org>,
       Richard Purdie <rpurdie@rpsys.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND] [PATCH -next 2/2] acpi,rfkill,backlight:
	comapl-laptop update - use rfkill switch subsystem
Message-ID: <20080710132934.GB1346@khazad-dum.debian.net>
References: <20080709231059.778d16f4@debian> <200807092357.28013.IvDoorn@gmail.com> <20080710011201.GC15729@khazad-dum.debian.net> <200807101517.38109.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807101517.38109.IvDoorn@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008, Ivo van Doorn wrote:
> > Do you want me to mark rfkill_force_state() as mandatory in the docs?  It
> > *IS* the preferred way to deal with firmware/hardware-initiated state
> > changes, after all.
> 
> Please do. Thanks.
> 
> > The rfkill subsystem will limp along without it, even when there are
> > hardware rfkill lines... but no OSD function will work, as the system will
> > pick up the change only when someone reads or writes to the state
> > attribute...
> 
> That reason alone is good enough for me to mark it mandatory for any drivers
> which features the rfkill key. :)

Input drivers don't need it at all, so it is not the drivers with rfkill
keys (input devices) that need it.  Rather, the drivers of wireless devices
with hardware rfkill lines are the ones who "need" it.

Yeah, I am definately adding it to the docs.  Did some locking fixes and
other dangerous crap too (in the sense that it can easily force me to down a
brown paperbag!), that needs to go to the list for RFC.  Will send what I
have done already after some light testing.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
