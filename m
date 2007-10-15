Return-Path: <linux-kernel-owner+w=401wt.eu-S1765525AbXJOR5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765525AbXJOR5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 13:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758735AbXJOR5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 13:57:22 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33748 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758701AbXJOR5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 13:57:21 -0400
Message-ID: <4713A9FA.4050209@garzik.org>
Date: Mon, 15 Oct 2007 13:57:14 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Boaz Harrosh <bharrosh@panasas.com>,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch] scsi: fix crash in gdth_timeout()
References: <20071015165534.GA17833@elte.hu> <alpine.LFD.0.999.0710151006400.6887@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710151006400.6887@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 15 Oct 2007, Ingo Molnar wrote:
>> A further problem is probably that the GDTH timer is not stopped by a
>> failed GDTH probe?
> 
> Indeed. Maybe this is a better fix?
> 
> That driver is pretty messy, and this should have been found ealier. 
> James? Boaz?

FWIW, the gdth driver was "super-messy".  With this latest SCSI pull, 
that severity has been successfully downgraded to "messy" :)

IMO some easy-to-fix breakage was inevitable with such a large volume of 
fundamental changes.

Honestly, the driver is probably rarely run by people that lack the 
hardware, I bet...

	Jeff



