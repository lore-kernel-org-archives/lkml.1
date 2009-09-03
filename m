Return-Path: <linux-kernel-owner+w=401wt.eu-S932260AbZICUnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbZICUnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 16:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932214AbZICUnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 16:43:18 -0400
Received: from mail.atheros.com ([12.36.123.2]:28389 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213AbZICUnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 16:43:17 -0400
Date: Thu, 3 Sep 2009 13:43:19 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: clear cfg80211_inform_bss() from kmemleak
 reports
Message-ID: <20090903204319.GC3701@mosca>
References: <1251958266-10692-1-git-send-email-lrodriguez@atheros.com>
 <1251962791.3336.3.camel@johannes.local>
 <43e72e890909031113r6010519br3b81d15cc331ba85@mail.gmail.com>
 <1252001837.9336.2.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1252001837.9336.2.camel@johannes.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 11:17:17AM -0700, Johannes Berg wrote:
> On Thu, 2009-09-03 at 11:13 -0700, Luis R. Rodriguez wrote:
> 
> > What I meant is it gobbles it up and spits another thing out. When it
> > gobbles it up the routine then uses kref_put().
> > 
> > > Why can it not track this?
> > 
> > It probably can, just not sure if it follows kref_put(), I was under
> > the impression here it doesn't and because of it we were getting false
> > positives. Catalin, can you confirm?
> 
> Ah I'd think that if it can't track it then that's because we use a
> pointer to the middle of the struct to keep track of it much of the
> time.

So you agree with the patch but not the commit log entry?

  Luis
