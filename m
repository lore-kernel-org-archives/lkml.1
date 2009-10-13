Return-Path: <linux-kernel-owner+w=401wt.eu-S1759969AbZJMOPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbZJMOPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756647AbZJMOPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:15:12 -0400
Received: from taz.net.au ([203.16.167.1]:57800 "EHLO taz.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbZJMOPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:15:12 -0400
Date: Wed, 14 Oct 2009 01:14:34 +1100
From: Craig Sanders <cas@taz.net.au>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: PROBLEM: kernel oops when tickless. 2.6.28.x to 2.6.31.3
Message-ID: <20091013141434.GA10613@taz.net.au>
References: <20091013090554.GB28715@taz.net.au>
 <4AD45169.2030507@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD45169.2030507@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 12:07:37PM +0200, Eric Dumazet wrote:
> This particular problem should/could be fixed in 2.6.31.4 by commit 
> d99927f4d93f36553699573b279e0ff98ad7dea6
> (net: Fix sock_wfree() race)
> 
> Please try to reproduce your tickless problem on 2.6.31.4 or latest
> Linus git tree


I've already compiled 2.6.31.4 @1000HZ, but I'll compile again and try
2.6.31.4 tickless in the morning. i'll report back with the result - it
usually takes a few days after booting before the Oops occurs, so if it
goes well that might not be until the weekend or early next week.

any idea what actually triggers it?  pppoe? malformed packets from the
internet?  udp/514 packets for rsyslogd?


thanks,

craig

-- 
craig sanders <cas@taz.net.au>
