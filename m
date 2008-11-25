Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbYKYRyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbYKYRyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 12:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbYKYRyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 12:54:35 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:3378 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbYKYRye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 12:54:34 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Date: Tue, 25 Nov 2008 09:54:13 -0800
From: "Matt Carlson" <mcarlson@broadcom.com>
To: "Willy Tarreau" <w@1wt.eu>
cc: "Matthew Carlson" <mcarlson@broadcom.com>,
       "Roger Heflin" <rogerheflin@gmail.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: WARNING: at net/sched/sch_generic.c:219
 dev_watchdog+0xfe/0x17e() with tg3 network
Message-ID: <20081125175413.GA9808@xw6200.broadcom.net>
References: <20081118065006.GC24654@1wt.eu>
 <20081120031101.GD26448@xw6200.broadcom.net>
 <20081120053746.GB15168@1wt.eu>
 <20081120184310.GB27712@xw6200.broadcom.net>
 <20081120212637.GB23844@1wt.eu>
 <20081120215318.GB27907@xw6200.broadcom.net>
 <20081124132744.GB24851@1wt.eu> <20081124215247.GA29696@1wt.eu>
 <20081125015223.GA9151@xw6200.broadcom.net>
 <20081125053128.GA32426@1wt.eu>
MIME-Version: 1.0
In-Reply-To: <20081125053128.GA32426@1wt.eu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Nov 2008 17:54:14.0492 (UTC)
 FILETIME=[D43D79C0:01C94F26]
X-WSS-ID: 6532E44461S16304706-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 09:31:28PM -0800, Willy Tarreau wrote:
> On Mon, Nov 24, 2008 at 05:52:23PM -0800, Matt Carlson wrote:
> (...)
> > > tg3: eth0: transmit timed out, resetting
> > > tg3: DEBUG: MAC_TX_STATUS[0000000b] MAC_RX_STATUS[00000006]
> > > tg3: DEBUG: RDMAC_STATUS[00000000] WDMAC_STATUS[00000008]
> > > tg3: tg3_stop_block timed out, ofs=1400 enable_bit=2
> > > tg3: tg3_stop_block timed out, ofs=c00 enable_bit=2
> > > tg3: tg3_stop_block timed out, ofs=4c00 enable_bit=2
> > > tg3: eth0: Link is down.
> > > tg3: eth0: Link is up at 100 Mbps, full duplex.
> > > tg3: eth0: Flow control is on for TX and on for RX.
> > > 
> > > The ease with which I reproduce it here clearly indicates that this is
> > > related to the switch, probably just the fact that it is at 100 Mbps.
> > > Unfortunately this evening I must go, but I still have one 100 Mbps
> > > switch somewhere at home, I'll reproduce the same test ASAP in order
> > > to bisect the issue.
> > > 
> > > Regards,
> > > Willy
> > 
> > Does turning off flow control help at all?
> 
> I have not tested but I will. I hope to be able to trigger the problem
> on other similar switches, because I'm only once a week connected to
> the culprit...

I can't say for certain, but I suspect the problem might be more
associated with the link speed than the particular switch you are using.
Can you try autoneg'ing down to a slower speed and see if that helps
make the problem more reproducable?


