Return-Path: <linux-kernel-owner+w=401wt.eu-S934372AbXK3N3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934372AbXK3N3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 08:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756402AbXK3N3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 08:29:15 -0500
Received: from venus.billgatliff.com ([209.251.101.201]:49320 "EHLO
	venus.billgatliff.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbXK3N3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 08:29:14 -0500
X-Greylist: delayed 1497 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2007 08:29:14 EST
Message-ID: <47500A4A.10006@billgatliff.com>
Date: Fri, 30 Nov 2007 07:04:10 -0600
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: David Brownell <david-b@pacbell.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Felipe Balbi <felipebalbi@users.sourceforge.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <andrew@sanpeople.com>, Tony Lindgren <tony@atomide.com>,
       eric miao <eric.y.miao@gmail.com>, Kevin Hilman <khilman@mvista.com>,
       Paul Mundt <lethal@linux-sh.org>, Ben Dooks <ben@trinity.fluff.org>
Subject: Re: [patch/rfc 2/4] pcf875x I2C GPIO expander driver
References: <200710291809.29936.david-b@pacbell.net>	<200710291851.49057.david-b@pacbell.net> <20071130133256.72385ea8@hyperion.delvare>
In-Reply-To: <20071130133256.72385ea8@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> !!(value & (1 << offset))
> is more efficiently written
> (value >> offset) & 1
>   

... but not more efficiently implemented.

Your version requires code to do the shift on live data at runtime.  
David's version lets the compiler create the mask once, at compile-time.



b.g.

-- 
Bill Gatliff
bgat@billgatliff.com

