Return-Path: <linux-kernel-owner+w=401wt.eu-S1763215AbYDVXxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763215AbYDVXxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 19:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763277AbYDVXxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 19:53:39 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:34404
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbYDVXxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 19:53:38 -0400
Message-ID: <480E7A59.6050802@microgate.com>
Date: Tue, 22 Apr 2008 18:52:57 -0500
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: khc@pm.waw.pl, jchapman@katalix.com, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] Re: WAN: new PPP code for generic HDLC
References: <480CEB7D.8070702@katalix.com>	<m33apdyajf.fsf@maximus.localdomain>	<480E5CB3.2080003@microgate.com> <20080422.150259.205494753.davem@davemloft.net>
In-Reply-To: <20080422.150259.205494753.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
 > Users say this to strong-hand developers, it's not something you
 > should ever take very seriously.  And even if Linux may simply not be
 > for them, well that's fine too, and implementing something as obscure
 > as HDLC PPP one way or the other is not going to change that.

Certainly not a big deal for Linux, but more
significant for vendors of HDLC hardware :-)

David Miller wrote:
 > I would have been more than happy if syncppp was retained and fixed
 > properly, instead of being abandoned and duplicated in one fell swoop.

I'd be happy with that also. I was responding to the
suggestion of merging generic HDLC PPP with the pppd implementation.
It's been suggested before, but doing so looks messy.

James Chapman wrote:
 > Paul Fulghum wrote:
 >> Many customers who choose to use generic HDLC PPP are *dead*
 >> set against the added complexity and (user space)
 >> components of using pppd even though it has more features.
 >
 > Are there technical reasons or is the complexity just a lack of
 > familiarity?

 From what I can tell it was an existing investment in scripts,
training, tools, naming conventions, etc. Even when
provided with new tools and scripts that do the same thing (as
far as I could tell) the response was suprisingly vehement against
change.

--
Paul

