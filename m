Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbXC0O1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbXC0O1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 10:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbXC0O1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 10:27:03 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:2430 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbXC0O1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 10:27:00 -0400
Message-ID: <460929B3.60303@rtr.ca>
Date: Tue, 27 Mar 2007 10:26:59 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Why is NCQ enabled by default by libata? (2.6.20)
References: <Pine.LNX.4.64.0703241232580.11608@p34.internal.lan> <4608B2B9.7090503@garzik.org>
In-Reply-To: <4608B2B9.7090503@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
>
> In some cases, NCQ firmware may be broken.  There is a Maxtor firmware 
> id, and some Hitachi ids that people are leaning towards recommending be 
> added to the libata 'horkage' list.

Western Digital "Raptor" drives (the 10K rpm things) are also somewhat
borked in NCQ mode, depending on the application.

Their firmware turns off all drive readahead during NCQ.
This makes them very good for an email/news server application,
but also causes them to suck for regular desktop applications.

Because of this, they use special software drivers under MSwin
which detect large sequential accesses, and avoid NCQ during such times.

Cheers

-ml
