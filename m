Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbYC1RMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbYC1RMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 13:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbYC1RMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 13:12:43 -0400
Received: from twin.jikos.cz ([213.151.79.26]:34056 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558AbYC1RMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 13:12:42 -0400
Date: Fri, 28 Mar 2008 18:12:22 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Michael Chan <mchan@broadcom.com>
cc: Harald Hannelius <harald@iki.fi>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: tg3 bad performance, lots of hardware interrupts
In-Reply-To: <1206726560.6866.5.camel@dell>
Message-ID: <Pine.LNX.4.64.0803281811420.32241@twin.jikos.cz>
References: <alpine.DEB.1.00.0803271532570.30549@penti.org>
 <20080327.144925.196529669.davem@davemloft.net> <1206666100.5368.6.camel@dell>
 <alpine.DEB.1.00.0803281440460.23558@penti.org> <1206726560.6866.5.camel@dell>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2008, Michael Chan wrote:

> > Phew, I thought that running ethtool -t was like doing stop-A-sync on 
> > a Sun. It took almost half an hour to run that ethtool -t command;
> Something is very wrong.  ethtool -t should only take a few seconds to
> complete.  You can try ethtool -t eth0 online to reduce the number of
> tests to see if it makes a difference.
> How many of these NICs do you have?  If you have more than one, do they
> all behave the same way?  Have they ever worked well before?

Harald, is the IRQ of eth0 shared with any other device? (cat 
/proc/interrupts will show).

-- 
Jiri Kosina
SUSE Labs

