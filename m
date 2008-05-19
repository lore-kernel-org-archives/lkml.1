Return-Path: <linux-kernel-owner+w=401wt.eu-S1758896AbYESWw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896AbYESWw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbYESWwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:52:19 -0400
Received: from nebensachen.de ([195.34.83.29]:36529 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbYESWwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:52:19 -0400
X-Hashcash: 1:20:080519:randy.dunlap@oracle.com::fm+A53lZRCCL+LoM:00000000000000000000000000000000000000Cx31
X-Hashcash: 1:20:080519:hmh@hmh.eng.br::KqTEKUKi6h/YVjdw:000A2yt
X-Hashcash: 1:20:080519:linux-kernel@vger.kernel.org::8hCy9pAMxZV4S0hy:0000000000000000000000000000000002JPQ
X-Hashcash: 1:20:080519:ivdoorn@gmail.com::Vnzm4qKR/WhYtC2O:00000000000000000000000000000000000000000000DA3S
X-Hashcash: 1:20:080519:trenn@suse.de::DpjoCO3PgbaaAEAJ:00001tjy
X-Hashcash: 1:20:080519:dtor@mail.ru::hUHyxeeTbtOMSLCq:00000Bi2g
From: Elias Oltmanns <eo@nebensachen.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-kernel@vger.kernel.org,
       Ivo van Doorn <IvDoorn@gmail.com>, Thomas Renninger <trenn@suse.de>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH 15/15] rfkill: document rw rfkill switches and clarify input subsystem interactions
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
	<1211136485-19878-16-git-send-email-hmh@hmh.eng.br>
	<20080519105108.8f843c47.randy.dunlap@oracle.com>
Date: Tue, 20 May 2008 00:52:34 +0200
In-Reply-To: <20080519105108.8f843c47.randy.dunlap@oracle.com> (Randy Dunlap's
	message of "Mon, 19 May 2008 10:51:08 -0700")
Message-ID: <87wslpvrd9.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Sun, 18 May 2008 15:48:05 -0300 Henrique de Moraes Holschuh wrote:
[...]
>> +===============================================================================
>> +3: Kernel API
>> +
>> +To build a driver with rfkill subsystem support, the driver should depend on
>> +the Kconfig symbol RFKILL; it should _not_ depend on RKFILL_INPUT.
>> +
>> +The hardware the driver talks to may be write-only (where the current state
>> +of the hardware is unknown), or read-write (where the hardware can be queried
>> +about its current state).
>> +
>> +The rfkill class will call the get_state hook of a device every time it needs
>> +to know the *real* current state of the hardware.  This can happen often.
>> +
>> +Some hardware provide events when its status change.  In these cases, it is
>
>                  provides

Wouldn't that be "changes" as welll?

Regards,

Elias
