Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbYKSW32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbYKSW32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 17:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbYKSW3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 17:29:18 -0500
Received: from ox1.aei.mpg.de ([194.94.224.6]:35501 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbYKSW3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 17:29:17 -0500
Date: Wed, 19 Nov 2008 23:29:40 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>
Subject: Re: iwlagn driver segfault in 2.6.28-rc3
Message-ID: <20081119222940.GA30846@localhost.aei.mpg.de>
References: <20081111143410.GA4401@ics.muni.cz> <1226560041.1115.945.camel@rc-desk> <20081116120621.GA3937@localhost.aei.mpg.de> <1ba2fa240811160429ld8cc080s7e023b0398eeda08@mail.gmail.com> <20081116125148.GA16746@localhost.aei.mpg.de> <1ba2fa240811161554r45d98ae7h3a37ae78c332a4dd@mail.gmail.com> <20081117003941.GA21367@localhost.aei.mpg.de> <20081119204524.GA30179@localhost.aei.mpg.de> <1ba2fa240811191406j5a116ad2h91873749cc96ab97@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ba2fa240811191406j5a116ad2h91873749cc96ab97@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20.Nov'08 at  0:06:05 +0200, Tomas Winkler wrote:
> >
> > I don't if the situation leading to the WARN() in your patch is the same
> > one which used to kill my wireless connection before (with the oops
> > in iwl_eeprom_query16 that started this thread), but the fact is
> > that my wifi is still working.
> 
> The second removal of invalid key corrupt the eeprom pointer
> in this line
> 
>       if (!test_and_clear_bit(priv->stations[sta_id].sta.key.key_offset,
>                  &priv->ucode_key_table))
> 
> as discovered by Yi so this patch also fix the immediate failure
> We are just not sure in what flow the key is removed second time and maybe
> there is an other issue behind it.

Ok, thanks for the explanation!

> The full log will be appreciated  but you've already helped a lot
> Thanks for your time

I thank you too for taking care of it, and now at least my wifi does not
die as before.

I uploaded the dmesg here

http://www.aei.mpg.de/~crmafra/dmesg-iwlwifi.txt

it contains the warnings including the first (not tainted), 
but the beginning of the log is missing because it was too big I guess.

But the boot messages are probably the same as the other dmesg
I've sent already in this thread.


