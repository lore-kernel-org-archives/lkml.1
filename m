Return-Path: <linux-kernel-owner+w=401wt.eu-S1763523AbXHWUTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763523AbXHWUTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 16:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbXHWUTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 16:19:15 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:40747 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbXHWUTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 16:19:14 -0400
Message-ID: <46CDEBB4.4020001@s5r6.in-berlin.de>
Date: Thu, 23 Aug 2007 22:19:00 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Andrew Burgess <aab@cichlid.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Firewire lockup on 2.6.22.3 in SMP but not UP, old drivers
References: <200708231606.l7NG6OPX017001@cichlid.com>
In-Reply-To: <200708231606.l7NG6OPX017001@cichlid.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Burgess wrote:
> what's the best way to proceed? Debug old drivers or
> switch to new ones?

As I mentioned in the branch of the discussion which lost the Cc: LKML,
this kind of bug looks like requiring a good look at the interaction of
raw1394's and ohci1394's locking (and maybe ieee1394's, but this seems
less likely).

It's hard work, and I don't have much experience with the code in
question nor do I have much time at the moment nor is there anybody else
who fixes ieee1394 subsystem bugs on a regular basis.  Nevertheless,
this kind of bugs should still be fixed in the "old" drivers.  They
haven't reached their end of life yet.
-- 
Stefan Richter
-=====-=-=== =--- =-===
http://arcgraph.de/sr/
