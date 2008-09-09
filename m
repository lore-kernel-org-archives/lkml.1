Return-Path: <linux-kernel-owner+w=401wt.eu-S1755066AbYIIFsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbYIIFsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 01:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbYIIFsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 01:48:12 -0400
Received: from mail.atheros.com ([12.36.123.2]:39651 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbYIIFsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 01:48:11 -0400
Date: Mon, 8 Sep 2008 22:48:05 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Marcel Holtmann <marcel@holtmann.org>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v5] cfg80211: Add new wireless regulatory
	infrastructure
Message-ID: <20080909054805.GB15742@tesla>
References: <1220643824-11398-1-git-send-email-lrodriguez@atheros.com> <1220668394.6714.109.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1220668394.6714.109.camel@californication>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2008 at 07:33:14PM -0700, Marcel Holtmann wrote:
> can we get a small document in Documentation/ that describes what has to
> be done for CRDA. That would help to ease the adaption and would allow
> us to point people to it. Nothing fancy, but some quick notes where to
> find it and what to put where.

Sure, I'm putting this together now.

> > Each driver can regulatory_hint() a regulatory domain
> > based on either their EEPROM mapped regulatory domain value to a
> > respective ISO/IEC 3166-1 country code or pass an internally built
> > regulatory domain. We also add support to let the user set the
> > regulatory domain through userspace in case of faulty EEPROMs to
> > further help compliance.
> 
> Do we have an example for all the possible ways? I think about something
> to help driver maintainers to move over and use the infrastructure the
> right way.

The only case I didn't test was the case for Intel's drivers, all other
drivers would use regulatory_hint() based on an alpha2 and that worked
swell. I found some issues with the case of providing a built regulatory
domain so I'm updating it now and am also updating some other parts of the
code for the old regulatory infrastructure, it seems there were a few
obvious issues we didn't catch there yet.

I hope to have the new doc for you with a few fixes and an example as to
what Intel drivers can do soon. I was hoping to get it all done by today but
that didn't happen.

  Luis
