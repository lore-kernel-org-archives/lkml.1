Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbYKGTu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbYKGTu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYKGTuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:50:39 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53190 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbYKGTui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:50:38 -0500
Date: Fri, 7 Nov 2008 11:50:26 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ics932s401: New driver
Message-ID: <20081107195025.GJ8668@plum>
Reply-To: djwong@us.ibm.com
References: <20081107191110.13201.20476.stgit@elm3a70.beaverton.ibm.com> <20081107113142.80d3b460.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107113142.80d3b460.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 11:31:42AM -0800, Andrew Morton wrote:
> 
> These are nice-looking drivers and I'm inclined to slip them into
> 2.6.28, but..
> 
> On Fri, 07 Nov 2008 11:11:10 -0800
> "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> 
> > +/* Addresses to scan */
> > +static const unsigned short normal_i2c[] = { 0x69, I2C_CLIENT_END };
> 
> These are the sorts of drivers which must go blindly poking at
> hardwired IO addresses, aren't they?  So if someone accidentally
> compiles it up and loads it, it will reach out and fry their pr0n
> collection?

Yep.  Alas, there's not a whole lot we can do about that, other than say
"insmodder beware".  Were it a hwmon driver, we could blacklist it in
sensors-detct, but Jean already NAK'd it for hwmon.  I plan to stick to
the DMI whitelist and add a DMI blacklist if necessary.

Of course, if you're really intent upon frying (someone else's) pr0n
collection... this chip can help with that.

--D
