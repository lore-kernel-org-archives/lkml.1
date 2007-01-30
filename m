Return-Path: <linux-kernel-owner+w=401wt.eu-S932579AbXA3DeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579AbXA3DeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 22:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932948AbXA3DeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 22:34:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932579AbXA3DeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 22:34:19 -0500
Subject: Re: Hidden SSID's
From: Dan Williams <dcbw@redhat.com>
To: Jouni Malinen <jkmaline@cc.hut.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070130030911.GA6637@jm.kir.nu>
References: <45BACB71.2080107@lwfinger.net>
	 <1169899689.25670.3.camel@localhost.localdomain>
	 <1170019717.30318.0.camel@johannes.berg>
	 <1170075611.2895.2.camel@localhost.localdomain>
	 <20070130030911.GA6637@jm.kir.nu>
Content-Type: text/plain
Date: Mon, 29 Jan 2007 22:36:48 -0500
Message-Id: <1170128208.3448.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-01-29 at 19:09 -0800, Jouni Malinen wrote:
> On Mon, Jan 29, 2007 at 08:00:11AM -0500, Dan Williams wrote:
> 
> > Well, there's no way a userspace program could depend on all hidden SSID
> > APs having the <hidden> tag, since if you stick in another,
> > non-ieee80211-stack card it won't be like that.  So I don't think we
> > should care about <hidden> in d80211, but I don't think we can remove it
> > from ieee80211 either.
> 
> Use of '<hidden>' is just not acceptable. IMHO, it should be removed
> from everywhere, including net/ieee80211. The sooner this is done, the
> better.

You're probably right.  Lets just pull it out of ieee80211 and be done.

dan



