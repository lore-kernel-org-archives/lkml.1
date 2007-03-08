Return-Path: <linux-kernel-owner+w=401wt.eu-S1750923AbXCHClH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750923AbXCHClH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 21:41:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbXCHClG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 21:41:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbXCHClE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 21:41:04 -0500
Subject: Re: [patch 097/101] revert "drivers/net/tulip/dmfe: support basic
	carrier detection"
From: Dan Williams <dcbw@redhat.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       jeff@garzik.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, netdev@vger.kernel.org, thomas@archlinux.org,
       val_henson@linux.intel.com, samuel.thibault@ens-lyon.org
In-Reply-To: <20070307101444.52cb2146@freekitty>
References: <20070307171035.150802805@mini.kroah.org>
	 <20070307171657.461008445@mini.kroah.org>
	 <20070307101444.52cb2146@freekitty>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 21:41:51 -0500
Message-Id: <1173321712.12017.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 10:14 -0800, Stephen Hemminger wrote:
> On Wed, 07 Mar 2007 09:12:12 -0800
> Greg KH <gregkh@suse.de> wrote:
> 
> > 
> > From: Andrew Morton <akpm@linux-foundation.org>
> > 
> > Revert 7628b0a8c01a02966d2228bdf741ddedb128e8f8.  Thomas Bachler
> > reports:
> > 
> >   Commit 7628b0a8c01a02966d2228bdf741ddedb128e8f8 (drivers/net/tulip/dmfe:
> >   support basic carrier detection) breaks networking on my Davicom DM9009. 
> >   ethtool always reports there is no link.  tcpdump shows incoming packets,
> >   but TX is disabled.  Reverting the above patch fixes the problem.
> > 
> 
> Carrier detection support is important and should be fixed rather than removed.

Definitely right.  If it doesn't work for your card, it needs to be
fixed for your card.

Dan


