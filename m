Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbZLBUi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbZLBUi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 15:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbZLBUi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 15:38:27 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:39304 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbZLBUi0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 15:38:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pMi9nKYj+2EBBoNEkk5cqzFqUrZzxZFy3rlcToIrxxTkf2PlYmkGqFrNok13vQdLqD
         3AxaS6l7gbszj/DvbU5EmHOa0KR5a52EdZwotsxrRHWj0DGPjbi2eDf7Hm3g6hr62urG
         W7Z29bsazM9buFTh4onlv8G18Tg9QaP1Fisig=
MIME-Version: 1.0
In-Reply-To: <20091130185813.GA32522@oksana.dev.rtsoft.ru>
References: <1259333060-24277-1-git-send-email-notasas@gmail.com>
	 <012301ca71ed$449cb930$544ff780@am.dhcp.ti.com>
	 <20091130185813.GA32522@oksana.dev.rtsoft.ru>
Date: Wed, 2 Dec 2009 22:38:31 +0200
Message-ID: <6ed0b2680912021238o29d7e773i9379369d7b277614@mail.gmail.com>
Subject: Re: [PATCH] power_supply: Add driver for TWL4030/TPS65950 BCI charger
From: Grazvydas Ignotas <notasas@gmail.com>
To: avorontsov@ru.mvista.com
Cc: Madhusudhan <madhu.cr@ti.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 8:58 PM, Anton Vorontsov
<avorontsov@ru.mvista.com> wrote:
> On Mon, Nov 30, 2009 at 12:45:20PM -0600, Madhusudhan wrote:
> [...]
>> > +   case POWER_SUPPLY_PROP_VOLTAGE_NOW:
>> > +           /* charging must be active for meaningful result */
>> > +           if (!is_charging) {
>>
>> How about putting a kern_info here?
>
> It might be better to return -EINVAL.

That causes lots of warnings from power_supply core (driver failed to
report XXX property), Not sure what to do here, I'd prefer to keep
returning 0.

>
> Thanks!
>
> --
> Anton Vorontsov
> email: cbouatmailru@gmail.com
> irc://irc.freenode.net/bd2
>
