Return-Path: <linux-kernel-owner+w=401wt.eu-S1761157AbXEYNh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761157AbXEYNh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 09:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbXEYNhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 09:37:18 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55027 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbXEYNhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 09:37:17 -0400
Message-ID: <4656E687.6070707@garzik.org>
Date: Fri, 25 May 2007 09:37:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Holger Eitzenberger <holger@my-eitzenberger.de>
CC: Robert Hancock <hancockr@shaw.ca>,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       linux-kernel@vger.kernel.org
Subject: Re: IDE/ATA: Intel i865-based mainboard, CDROM not detected
References: <fa.mF3GWjxaUtH4GJg0vJ8o0F2EuwE@ifi.uio.no>	<4651464B.4080903@shaw.ca> <87fy5lhxu2.fsf@kruemel.my-eitzenberger.de>
In-Reply-To: <87fy5lhxu2.fsf@kruemel.my-eitzenberger.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Holger Eitzenberger wrote:
> just curious, what makes you think that AHCI is better wrt performance?

NCQ support, CPU cycle savings, no silly DMA limits (supports larger 
clustered chunks of data, less bouncing), supports 64-bit (no bouncing 
on 64-bit), eliminates use of PIO, the list goes on.

	Jeff


