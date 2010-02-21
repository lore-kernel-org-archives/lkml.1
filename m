Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab0BUKGQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 05:06:16 -0500
Received: from senator.holtmann.net ([87.106.208.187]:43293 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab0BUKGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 05:06:14 -0500
Subject: Re: [PATCH 2/2] enhance /sys/class/rfkill/<rfkill>/state interface
From: Marcel Holtmann <marcel@holtmann.org>
To: Florian Mickler <florian@mickler.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <20100221000716.29ad3e90@schatten.dmk.lab>
References: <1266702045-6062-1-git-send-email-florian@mickler.org>
	 <1266702045-6062-3-git-send-email-florian@mickler.org>
	 <1266704090.10980.0.camel@jlt3.sipsolutions.net>
	 <20100221000716.29ad3e90@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Feb 2010 11:07:35 +0100
Message-ID: <1266746855.18491.0.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

> > > Introduce a new state-value RFKILL_STATE_SOFT_AND_HARD_BLOCKED
> > > which is returned only through the sysfs state file.
> > > The other interfaces are designed so that they don't need this extra
> > > state.
> > > 
> > > This allows the sysfs to represent all possible states an rfkill
> > > driver can
> > > have.
> > > 
> > > Signed-off-by: Florian Mickler <florian@mickler.org>
> > > ---
> > > 
> > > After stumbling over this arbitrary limitation of
> > > sys/class/rfkill/*/state I
> > > wondered what would hinder this patch?
> > 
> > This is not backward compatible, so can't be done.
> > 
> > johannes
> 
> hmm... ah, i see... if driver is in hard'n'soft-block state 
> an userspace program would expect to read hardblock instead of the
> new hard'n'softblock-state... 
> now that i think of it, it even becomes obvious :) 

a userspace program would be expected to use /dev/rfkill and do this
properly. Don't bother with sysfs at all.

Regards

Marcel


