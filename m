Return-Path: <linux-kernel-owner+w=401wt.eu-S935044AbXK3Nhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935044AbXK3Nhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 08:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934889AbXK3Ng7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 08:36:59 -0500
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:4595 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933811AbXK3Ng6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 08:36:58 -0500
Date: Fri, 30 Nov 2007 14:36:54 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Bill Gatliff <bgat@billgatliff.com>
Cc: David Brownell <david-b@pacbell.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Felipe Balbi <felipebalbi@users.sourceforge.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <andrew@sanpeople.com>, Tony Lindgren <tony@atomide.com>,
       eric miao <eric.y.miao@gmail.com>, Kevin Hilman <khilman@mvista.com>,
       Paul Mundt <lethal@linux-sh.org>, Ben Dooks <ben@trinity.fluff.org>
Subject: Re: [patch/rfc 2/4] pcf875x I2C GPIO expander driver
Message-ID: <20071130143654.3fd39ffe@hyperion.delvare>
In-Reply-To: <47500A4A.10006@billgatliff.com>
References: <200710291809.29936.david-b@pacbell.net>
	<200710291851.49057.david-b@pacbell.net>
	<20071130133256.72385ea8@hyperion.delvare>
	<47500A4A.10006@billgatliff.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bill,

On Fri, 30 Nov 2007 07:04:10 -0600, Bill Gatliff wrote:
> Jean Delvare wrote:
> > !!(value & (1 << offset))
> > is more efficiently written
> > (value >> offset) & 1
> 
> ... but not more efficiently implemented.
> 
> Your version requires code to do the shift on live data at runtime.  
> David's version lets the compiler create the mask once, at compile-time.

I don't understand. How could the compiler create the mask at
compile-time when "offset" is only known at runtime?

Anyway, I just checked and gcc (4.1.2 on x86_86) generates the same
code for both expressions, so there's not much to argue about. David,
feel free to ignore my comment if you prefer your implementation :)

-- 
Jean Delvare
