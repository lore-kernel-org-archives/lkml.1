Return-Path: <linux-kernel-owner+w=401wt.eu-S1752516AbXA2Pn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbXA2Pn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 10:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbXA2Pn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 10:43:57 -0500
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:50034 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752511AbXA2Pn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 10:43:56 -0500
Message-ID: <45BE1639.6040106@lwfinger.net>
Date: Mon, 29 Jan 2007 09:43:53 -0600
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: roucaries bastien <roucaries.bastien@gmail.com>,
       bcm43xx devel <Bcm43xx-dev@lists.berlios.de>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
Subject: Re: Bcm43xx oops after suspend to disk
References: <45B92488.6090908@lwfinger.net> <45B92536.2080909@lwfinger.net>	<195c7a900701251530m409878a8id301c7cada76f342@mail.gmail.com>	<45BA246B.6030505@lwfinger.net> <20070129115842.GA4928@ucw.cz>	<195c7a900701290455o3ff9fc15k305637f8ced24caf@mail.gmail.com> <20070129140408.GA19379@srcf.ucam.org>
In-Reply-To: <20070129140408.GA19379@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Mon, Jan 29, 2007 at 01:55:41PM +0100, roucaries bastien wrote:
>> -       return 0;
>> +       return bcm43xx_init_one(pdev, NULL);
>> }
> 
> While this may well work (it's basically equivalent to unloading and 
> reloading the module), it's not a long-term fix - userspace is going to 
> notice the interface vanishing and reappearing. Larry, I guess you just 
> mean this as a test patch?
> 

Yes. If this doesn't work, then we have real problems. If it does, then I try to find the part that
is missing in the current code.

Larry

