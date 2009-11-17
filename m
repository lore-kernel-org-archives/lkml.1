Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674AbZKQNc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbZKQNc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 08:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbZKQNc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 08:32:57 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:57229 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZKQNc4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 08:32:56 -0500
Subject: Re: Shared i2c adapter locking
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Miller <davem@davemloft.net>
Cc: khali@linux-fr.org, sfr@canb.auug.org.au, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       mika.kuoppala@nokia.com, linux-i2c@vger.kernel.org
In-Reply-To: <20091117.035147.80164577.davem@davemloft.net>
References: <20091105150715.692b5200@hyperion.delvare>
	 <20091117193313.b750804e.sfr@canb.auug.org.au>
	 <20091117103554.03971b2f@hyperion.delvare>
	 <20091117.035147.80164577.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Organization: Solarflare Communications
Date: Tue, 17 Nov 2009 13:32:54 +0000
Message-Id: <1258464774.2732.6.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 17 Nov 2009 13:33:00.0560 (UTC) FILETIME=[7B520100:01CA678A]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17014.005
X-TM-AS-Result: No--36.215800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-17 at 03:51 -0800, David Miller wrote:
> From: Jean Delvare <khali@linux-fr.org>
> Date: Tue, 17 Nov 2009 10:35:54 +0100
> 
> > If you did and something is still not clear, please let me know. My
> > understanding is that the action token is in David's hands now.
> 
> So what exactly do I need to do?
> 
> All I see that needs to happen is to pull from Linus's tree into
> net-2.6
> 
> But frankly I don't see how that helps resolve anything in linux-next
> since Stephen starts with Linus's tree then pulls in everyone's work.
> 
> Or is that pull necessary so that some other patch can be applied
> to net-2.6 or similar?

There is now a conflict between this in Linus's tree:

commit afa08974fe80c198b8650f73ed8ab59135ca10d0
Author: Jean Delvare <khali@linux-fr.org>
Date:   Sat Nov 7 13:10:46 2009 +0100

    i2c: Add an interface to lock/unlock an I2C bus segment

and ﻿this in net-next-2.6:

commit c9597d4f89565b6562bd3026adbe6eac6c317f47
Author: Ben Hutchings <bhutchings@solarflare.com>
Date:   Fri Oct 23 08:29:33 2009 +0000

    sfc: Merge sfe4001.c into falcon_boards.c

You will need to merge Linus's tree into net-next-2.6 and resolve the
conflict by applying Jean's changes to drivers/net/sfc/falcon_boards.c.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

