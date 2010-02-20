Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965Ab0BTXHV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 18:07:21 -0500
Received: from ist.d-labs.de ([213.239.218.44]:56824 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087Ab0BTXHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 18:07:18 -0500
Date: Sun, 21 Feb 2010 00:07:16 +0100
From: Florian Mickler <florian@mickler.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 2/2] enhance /sys/class/rfkill/<rfkill>/state interface
Message-ID: <20100221000716.29ad3e90@schatten.dmk.lab>
In-Reply-To: <1266704090.10980.0.camel@jlt3.sipsolutions.net>
References: <1266702045-6062-1-git-send-email-florian@mickler.org>
	<1266702045-6062-3-git-send-email-florian@mickler.org>
	<1266704090.10980.0.camel@jlt3.sipsolutions.net>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Feb 2010 23:14:48 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Sat, 2010-02-20 at 22:40 +0100, florian@mickler.org wrote:
> > Introduce a new state-value RFKILL_STATE_SOFT_AND_HARD_BLOCKED
> > which is returned only through the sysfs state file.
> > The other interfaces are designed so that they don't need this extra
> > state.
> > 
> > This allows the sysfs to represent all possible states an rfkill
> > driver can
> > have.
> > 
> > Signed-off-by: Florian Mickler <florian@mickler.org>
> > ---
> > 
> > After stumbling over this arbitrary limitation of
> > sys/class/rfkill/*/state I
> > wondered what would hinder this patch?
> 
> This is not backward compatible, so can't be done.
> 
> johannes

hmm... ah, i see... if driver is in hard'n'soft-block state 
an userspace program would expect to read hardblock instead of the
new hard'n'softblock-state... 
now that i think of it, it even becomes obvious :) 

cheers,
Flo


