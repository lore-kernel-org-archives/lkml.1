Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbXFKP0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbXFKP0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 11:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbXFKP0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 11:26:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190AbXFKPZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 11:25:59 -0400
Subject: Re: RFC airo : wpa support
From: Dan Williams <dcbw@redhat.com>
To: matthieu castet <castet.matthieu@free.fr>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
In-Reply-To: <463BB946.3000807@free.fr>
References: <463BB946.3000807@free.fr>
Content-Type: text/plain
Date: Mon, 11 Jun 2007 11:18:53 -0400
Message-Id: <1181575133.4656.3.camel@xo-28-0B-88.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-05 at 00:52 +0200, matthieu castet wrote: 
> Hi,
> 
> I attach a diff against 2.6.21 for adding wpa support for airo driver.
> In then end of 2005 I manage to make work wpa but the code was really 
> ugly. I manage to find some time to clean it.
> 
> 
> To support wpa, a new interface of the firmware should be used. This 
> interface is incompatible with the old interface and using both 
> interface at the same time make the firmware hang.
> 
> Porting OPEN and WEP mode to new interface need some driver rewrite, and 
> the old interface should be keep for the older cards (or the cards that 
> doesn't have newer firmware).

What's involved in doing this?  Do you have any pointers or sample code
that could be used here?

I'd assume that we'd just use AUTH_CIPHER_WEP/AUTH_CIPHER_NONE and
AUTH_KEY_MGMT_NONE in ConfigRidExtra.  But where does the WEP key
material go, does it get stuffed into the WpaKeyRid too or somewhere
else?

Dan

> That's why I didn't do it, and I added a module parameter for choosing 
> between the old driver behavior (with no wpa support) or the driver with 
> wpa only support.
> 
> 
> The wireless extension handlers are a bit ugly, I will be very happy, if 
> somebody could help me to clean them.
> 
> Any comments are appreciated.
> 
> 
> Matthieu
> 
> 
> PS : the lastest version of the driver can be found in 
> http://svn.gna.org/viewcvs/airo-wpa/branches/kernel/
> 
> PS2 : There is some remaining trace in the driver for debug purpose, 
> that will be removed in the final version

