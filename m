Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbZH3UV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbZH3UV2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 16:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbZH3UV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 16:21:28 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:38188 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752606AbZH3UV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 16:21:27 -0400
Date: Sun, 30 Aug 2009 22:26:06 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: David Dillow <dave@thedillows.org>
Cc: roma1390 <roma1390@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: r8169 NETDEV WATCHDOG: eth0: transmit timed out [0/8]
Message-ID: <20090830202606.GA24479@electric-eye.fr.zoreil.com>
References: <b410963b0908290216x19206aa6o4458bb55b5578a04@mail.gmail.com> <1251553180.13707.16.camel@obelisk.thedillows.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251553180.13707.16.camel@obelisk.thedillows.org>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Dillow <dave@thedillows.org> :
> On Sat, 2009-08-29 at 12:16 +0300, roma1390 wrote:
> > Using 3 different r8169 devices on 2 servers (from 2 server so 100% of
> > population) we getting
> > 
> > NETDEV WATCHDOG: eth0: transmit timed out
> 
> You're running an old version of the kernel, and the driver was patched
> to fix that issue in 2.6.30. It is also in the 2.6.29.x stable series,
> and I think maybe the 2.6.28.x series -- please try those and see if you
> problem is resolved.

The fix in 2.6.28.x targets the netdev watchdog problem at boot time only.
2.6.28.x does not include something similar to
f11a377b3f4e897d11f0e8d1fc688667e2f19708 so 2.6.28.x will almost surely
not fit.

-- 
Ueimor
