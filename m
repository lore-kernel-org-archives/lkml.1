Return-Path: <linux-kernel-owner+w=401wt.eu-S1759052AbYESW5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052AbYESW5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYESW4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:56:54 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:62393 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbYESW4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:56:52 -0400
Message-ID: <10083724.1211237793980.JavaMail.oracle@acsmt301.oracle.com>
Date: Mon, 19 May 2008 17:56:33 -0500 (CDT)
From: Randy Dunlap <RANDY.DUNLAP@ORACLE.COM>
To: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH 15/15] rfkill: document rw rfkill switches and clarify input subsystem interactions
Cc: Dmitry Torokhov <dtor@mail.ru>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Ivo van Doorn <IvDoorn@gmail.com>
In-Reply-To: <87wslpvrd9.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
	<1211136485-19878-16-git-send-email-hmh@hmh.eng.br>
	<20080519105108.8f843c47.randy.dunlap@oracle.com> <87wslpvrd9.fsf@denkblock.local>
X-Priority: 3
X-Mailer: Oracle Webmail Client(UIX)
Content-Language: en-US
Accept-Language: en-US
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Original Message ---
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > On Sun, 18 May 2008 15:48:05 -0300 Henrique de Moraes Holschuh wrote:
> [...]
> >> +===============================================================================
> >> +3: Kernel API
> >> +
> >> +To build a driver with rfkill subsystem support, the driver should depend on
> >> +the Kconfig symbol RFKILL; it should _not_ depend on RKFILL_INPUT.
> >> +
> >> +The hardware the driver talks to may be write-only (where the current state
> >> +of the hardware is unknown), or read-write (where the hardware can be queried
> >> +about its current state).
> >> +
> >> +The rfkill class will call the get_state hook of a device every time it needs
> >> +to know the *real* current state of the hardware.  This can happen often.
> >> +
> >> +Some hardware provide events when its status change.  In these cases, it is
> >
> >                  provides
> 
> Wouldn't that be "changes" as welll?

Yes.  Thanks.

~Randy


