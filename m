Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbYIKI6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbYIKI6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 04:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYIKI6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 04:58:45 -0400
Received: from hpsmtp-eml16.kpnxchange.com ([213.75.38.116]:22864 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787AbYIKI6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 04:58:45 -0400
From: Frans Pop <elendil@planet.nl>
To: Marcel Holtmann <holtmann@linux.intel.com>
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
Date: Thu, 11 Sep 2008 10:58:41 +0200
User-Agent: KMail/1.9.9
Cc: davem@davemloft.net, dwmw2@infradead.org, jeffm@suse.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
References: <1221087719.13621.50.camel@macbook.infradead.org> <20080910.160505.14060698.davem@davemloft.net> <1221088512.13621.58.camel@macbook.infradead.org> <20080910.162423.40167601.davem@davemloft.net> <20080910.162423.40167601.davem@davemloft.net> <1221119068.6309.8.camel@californication>
In-reply-To: <1221119068.6309.8.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809111058.42362.elendil@planet.nl>
X-OriginalArrivalTime: 11 Sep 2008 08:58:42.0624 (UTC) FILETIME=[972C4400:01C913EC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann wrote:
> it is that the Debian maintainer screwed this up.

WRONG! NOT TRUE! FUD!
The Debian maintainer has done nothing of the kind.

> To shed some light into the problem with Debian/Ubuntu. They install the
> firmware in /lib/firmware/`uname -r`/

Debian does no such thing! It may be that Ubuntu does this, but that does 
NOT mean that Debian does too.

Feel free to examine any of the packages here and check where they install 
their firmware files:
http://packages.debian.org/search?suite=sid&searchon=names&keywords=firmware

Examples:
http://packages.debian.org/sid/all/firmware-qlogic/filelist
http://packages.debian.org/sid/all/firmware-bnx2/filelist

> Problem comes when installing let say 2.6.27 since then the firmware
> will be looked up in /lib/firmware/ and /lib/firmware/2.6.27/ and
> actually it will not be found. Since it is in /lib/firmware/2.6.26-xx/
> or something similar.
> 
> So having the kernel install everything in /lib/firmware works just fine
> with every distro. However looking for firmware that is not shipped with
> the kernel, we have a problem since Debian/Ubuntu just not installs it
> in the right directory. And there is nothing the kernel can do about it
> since it will not touch firmware it doesn't ship. The distro has to fix
> their firmware or the users have to place a copy in /lib/firmware/ where
> it actually should have been in the first place.

This is a ridiculously simplified view of the issue. Why can't you at 
least acknowledge that people were faced with a real problem _without_ 
proper guidance, support or transition path from their upstream source 
and made their best effort to solve that issue.

Note that this thread was started by someone from Suse, not Debian or 
Ubuntu.

Cheers,
FJP
