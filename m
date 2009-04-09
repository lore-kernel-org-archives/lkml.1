Return-Path: <linux-kernel-owner+w=401wt.eu-S1757853AbZDIEWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853AbZDIEWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 00:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbZDIEWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 00:22:45 -0400
Received: from sandeen.net ([209.173.210.139]:31626 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071AbZDIEWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 00:22:44 -0400
Message-ID: <49DD7812.1030408@sandeen.net>
Date: Wed, 08 Apr 2009 23:22:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Lee Revell <rlrevell@joe-job.com>
CC: Ric Wheeler <ricwheeler@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Ric Wheeler <rwheeler@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Mikulas Patocka <mpatocka@redhat.com>,
       device-mapper development <dm-devel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ak@linux.intel.com, "MASON, CHRISTOPHER" <CHRIS.MASON@oracle.com>
Subject: Re: [dm-devel] Barriers still not passing on simple dm devices...
References: <20090324150517.GX27476@kernel.dk>	 <Pine.LNX.4.64.0903251825310.8027@hs20-bc2-1.build.redhat.com>	 <20090326084205.GG27476@kernel.dk>	 <Pine.LNX.4.64.0903302314500.6158@hs20-bc2-1.build.redhat.com>	 <20090331104933.GJ5178@kernel.dk>	 <Pine.LNX.4.64.0904021923040.19415@hs20-bc2-1.build.redhat.com>	 <20090403081131.GP5178@kernel.dk> <49D77AC3.3020207@redhat.com>	 <20090405012839.GF7553@mit.edu> <49D89C06.1060700@gmail.com> <75b66ecd0904051814n353bb69bp76a38e36cac4d3fe@mail.gmail.com>
In-Reply-To: <75b66ecd0904051814n353bb69bp76a38e36cac4d3fe@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Revell wrote:
> On Sun, Apr 5, 2009 at 7:54 AM, Ric Wheeler <ricwheeler@gmail.com> wrote:
>> One thing to point out here is that there are a lot of "servers" in high end
>> data centers that do not have UPS backup. Those racks full of 1U and 2U
>> boxes that are used to make "grids", "clouds" and so on often are built with
>> as much gear as you can stuff in a rack - no batteries or UPS to be seen, so
>> they are really quite similar to the normal desktop or home systems that we
>> normally run at home :-)
> 
> These days even bargain basement data centers provide UPS functionality for
> you, via generator backup and A/B power.
> 
> Lee

In that case, you can turn off barriers.  It's still no excuse, IMHO,
for us to ship a journaling filesystem configuration which is known to
corrupt on power loss, by default.

-Eric
