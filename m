Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbZGAQ3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbZGAQ3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 12:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbZGAQ3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 12:29:46 -0400
Received: from smurf.noris.de ([192.109.102.42]:32378 "EHLO
	smurf.intern.smurf.noris.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752781AbZGAQ3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 12:29:46 -0400
Date: Wed, 1 Jul 2009 18:28:37 +0200
From: Matthias Urlichs <smurf@smurf.noris.de>
To: Andy Whitcroft <apw@canonical.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Reduce AACRAID hardware queue size
Message-ID: <20090701162837.GE7964@kiste.smurf.noris.de>
References: <1245756306-29023-1-git-send-email-apw@canonical.com> <1245756306-29023-2-git-send-email-apw@canonical.com> <1245771089.4149.88.camel@mulgrave.site> <20090623160408.GA22716@smurf.noris.de> <20090701155843.GE13837@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701155843.GE13837@shadowen.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Smurf-Spam-Score: -2.6 (--)
X-Smurf-Whitelist: +relay_from_hosts
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andy Whitcroft:
> > > echo 63 > /sys/block/<disk>/queue/max_sectors_kb
> > > 
> > Thank you, I'll do that tonight.
> 
> How did this one work out for you?  I don't think I saw a reply either
> way?
> 
Bah. Thanks for the reminder; I totally forgot to send that email.
(Too much other stuff in my life right now. (Mostly good, fortunately.))

Short version: It didn't. The controller now seems dead.
It times out all the time, and is unable to find any disks.

Unfortunately the thing is built-in and can't easily be replaced;
I don't have any warranty info for this machine either, so ...

-- 
Matthias Urlichs   |   {M:U} IT Design @ m-u-it.de   |  smurf@smurf.noris.de
Disclaimer: The quote was selected randomly. Really. | http://smurf.noris.de
v4sw7$Yhw6+8ln7ma7u7L!wl7DUi2e6t3TMWb8HAGen6g3a4s6Mr1p-3/-6 hackerkey.com
 - -
Sex is a misdemeanor -- the more I miss, de meaner I get.
