Return-Path: <linux-kernel-owner+w=401wt.eu-S1031730AbXEEDyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031730AbXEEDyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 23:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031732AbXEEDyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 23:54:20 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57322 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031730AbXEEDyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 23:54:19 -0400
X-Sasl-enc: X+XZTW2hFaW+MKkDHg4hAoQwYagNsxJxNAxHG/0GV+Yn 1178337258
Date: Sat, 5 May 2007 00:54:13 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Shem Multinymous <multinymous@gmail.com>
Cc: Anton Vorontsov <cbou@mail.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 3/8] Universal power supply class (was: battery class)
Message-ID: <20070505035413.GB21359@khazad-dum.debian.net>
References: <20070503213139.GC20067@zarina> <41840b750705032155w21d98b5g6236daf9bff66606@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41840b750705032155w21d98b5g6236daf9bff66606@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 May 2007, Shem Multinymous wrote:
> >+enum power_supply_type {
> >+       POWER_SUPPLY_TYPE_BATTERY = 0,
> >+       POWER_SUPPLY_TYPE_UPS,
> >+       POWER_SUPPLY_TYPE_AC,
> >+       POWER_SUPPLY_TYPE_USB,
> >+};
> 
> How about dumb (non-USB) DC power? Any reason to distinguish it from AC?

Hmm, if it should not be distinguished, it is better to rename AC to
something that means continuous power.  But I'd rather have it AC and DC, as
something might have both supplies separate, and you might want to
differentiate them for some (human interface) reason.  After all, USB and DC
are not really different anyway...

Anyway, what IS the difference between UPS and battery, or UPS and AC/DC for
that matter?  When should UPS be used?  If you have UPS there, should not
MGG (motor-generator group) also be provided?

Given that USB-power *is* usually also "dumb" (i.e. it doesn't do any
control signaling over the USB bus for power-control purposes), IMHO it
might be better to have just battery, AC and DC as types.  And a primary and
secondary notion too, as that is common.  It would be generic.

Or maybe I just didn't get the idea behind the "type" attribute :-)

I'd appreciate if these were documented in the text file.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
