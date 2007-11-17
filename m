Return-Path: <linux-kernel-owner+w=401wt.eu-S1760395AbXKQKjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760395AbXKQKjP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 05:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbXKQKi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 05:38:59 -0500
Received: from smtp-106-saturday.nerim.net ([62.4.16.106]:55425 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752855AbXKQKi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 05:38:58 -0500
Date: Sat, 17 Nov 2007 11:38:55 +0100
From: Jean Delvare <khali@linux-fr.org>
To: David Brownell <david-b@pacbell.net>
Cc: "eric miao" <eric.y.miao@gmail.com>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Bill Gatliff" <bgat@billgatliff.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <andrew@sanpeople.com>,
       "Tony Lindgren" <tony@atomide.com>, "Kevin Hilman" <khilman@mvista.com>,
       "Paul Mundt" <lethal@linux-sh.org>, "Ben Dooks" <ben@trinity.fluff.org>
Subject: Re: [patch/rfc 1/4] GPIO implementation framework
Message-ID: <20071117113855.7532e477@hyperion.delvare>
In-Reply-To: <200711132036.14927.david-b@pacbell.net>
References: <200710291809.29936.david-b@pacbell.net>
	<f17812d70711131704r4de82efat757dbb5479273ce2@mail.gmail.com>
	<f17812d70711131704l6b0562ffmec6e7e1981130898@mail.gmail.com>
	<200711132036.14927.david-b@pacbell.net>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 20:36:13 -0800, David Brownell wrote:
> On Tuesday 13 November 2007, eric miao wrote:
> >  	if (!requested)
> > -		printk(KERN_DEBUG "GPIO-%d autorequested\n",
> > -				chip->base + offset);
> > +		pr_debug("GPIO-%d autorequested\n", gpio);
> 
> Leave the printk in ... this is the sort of thing we want
> to see fixed, which becomes unlikely once you hide such
> diagnostics.  And for that matter, what would be enabling
> the "-DDEBUG" that would trigger a pr_debug() message?

The original code isn't correct either. Either this is a debug message
and indeed pr_debug() should be used, or it's not and KERN_DEBUG should
be replaced by a lower log level.

-- 
Jean Delvare
