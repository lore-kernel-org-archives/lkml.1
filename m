Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbZCTUdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbZCTUdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 16:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbZCTUdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 16:33:21 -0400
Received: from mail.lang.hm ([64.81.33.126]:43103 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbZCTUdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 16:33:21 -0400
Date: Fri, 20 Mar 2009 13:32:44 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: =?ISO-8859-15?Q?Daniel_Kr=FCger?= 
	<daniel.krueger@systec-electronic.com>,
       Robert Schwebel <r.schwebel@pengutronix.de>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Michael Olbrich <mol@pengutronix.de>,
       Wolfram Sang <wsa@pengutronix.de>,
       Marc Kleine-Budde <mkl@pengutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: The Linux Staging tree, what it is and is not.
In-Reply-To: <20090320153713.65bf8e2d@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.1.10.0903201332130.16753@asgard.lang.hm>
References: <20090318183232.GA11594@kroah.com> <20090320005808.GM5367@pengutronix.de> <20090320100146.6599f671@lxorguk.ukuu.org.uk> <20090320103545.GQ5367@pengutronix.de> <20090320105556.4375176d@lxorguk.ukuu.org.uk> <20090320111552.GS5367@pengutronix.de>
 <49C3B33F.1020905@systec-electronic.com> <20090320153713.65bf8e2d@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009, Alan Cox wrote:

>> information of what to copy to where comes from the object dictionary.
>> But it is possible to extract this information from the objdict and pass
>> it via generic structures (e.g. something like IO vectors) to the PDO
>> module in kernel. The information flow of the configuration data is
>> one-way only, from userspace to kernel. This is what I plan to implement
>> in openPOWERLINK, because the copy information can also be passed to a
>> special hardware like a DMA controller.
>
> Ok so your hardware in fact really is oriented around an mmap type
> interface ?

what I understand from this thread is that the hardware is a standard 
ethernet card.

David Lang
