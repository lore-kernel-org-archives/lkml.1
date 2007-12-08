Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbXLHUFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbXLHUFp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbXLHUFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:05:33 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:42881 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400AbXLHUFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:05:32 -0500
Message-ID: <475AF8D0.1090407@garzik.org>
Date: Sat, 08 Dec 2007 15:04:32 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Theodore Tso <tytso@mit.edu>, Mike McGrath <mmcgrath@redhat.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
       Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org,
       hmh@debian.org
Subject: Re: entropy gathering (was Re: Why does reading from /dev/urandom
 deplete entropy so much?)
References: <4755D350.1080801@redhat.com> <20071204223345.GJ19691@waste.org> <4756B50B.3060100@redhat.com> <20071205144934.GL7259@thunk.org> <1197099477.20786.149.camel@perihelion> <20071208173204.GI17037@thunk.org> <475AD585.7020908@redhat.com> <20071208174908.GJ17037@thunk.org> <20071208181525.GL19691@waste.org> <475AF241.5000809@garzik.org> <20071208195342.GO19691@waste.org>
In-Reply-To: <20071208195342.GO19691@waste.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Sat, Dec 08, 2007 at 02:36:33PM -0500, Jeff Garzik wrote:
>> As an aside...
>>
>> Speaking as the maintainer rng-tools, which is the home of the hardware 
>> RNG entropy gathering daemon...
>>
>> I wish somebody (not me) would take rngd and several other projects, and 
>> combine them into a single actively maintained "entropy gathering" package.
> 
> I think we should re-evaluate having an internal path from the hwrngs
> to /dev/[u]random, which will reduce the need for userspace config
> that can go wrong.

That's a bit of a tangent on a tangent.  :)  Most people don't have a 
hardware RNG.

But as long as there are adequate safeguards against common hardware 
failures (read: FIPS testing inside the kernel), go for it.

	Jeff



