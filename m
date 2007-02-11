Return-Path: <linux-kernel-owner+w=401wt.eu-S932870AbXBKXGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870AbXBKXGN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 18:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932906AbXBKXGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 18:06:13 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:39094 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932870AbXBKXGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 18:06:12 -0500
Subject: Re: [PATCH] Re: NAK new drivers without proper power management?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Daniel Barkalow <barkalow@iabervon.org>, Willy Tarreau <w@1wt.eu>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.osdl.org>
In-Reply-To: <200702111953.02229.rjw@sisk.pl>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no>
	 <200702111536.20871.rjw@sisk.pl>
	 <Pine.LNX.4.64.0702111154570.20138@iabervon.org>
	 <200702111953.02229.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 10:06:06 +1100
Message-Id: <1171235166.4493.100.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sun, 2007-02-11 at 19:53 +0100, Rafael J. Wysocki wrote:
> > Having drivers explicitly marked as to whether they are safe is a good kernel
> > feature; what to do if they're not is policy.
> 
> That's true, but I assume that the people who opt for doing that are also
> willing to take part in the review of the drivers. :-)

Absolutely :)

> Well, I don't think so.  Let's estimate the number of drivers that define
> .resume() right now:
> 
> $ grep -I -l -r '.resume =' linux-2.6.20/drivers/ | wc
>     102     102    4169

I think the '.resume =' doesn't help - some have tabs. I ran '\.resume'
and got 351.

It would be interesting to see how many struct pci_driver etc instances
lack resume methods.

Regards,

Nige

