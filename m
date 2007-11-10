Return-Path: <linux-kernel-owner+w=401wt.eu-S1762929AbXKJDF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762929AbXKJDF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 22:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbXKJDFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 22:05:14 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:34679 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbXKJDFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 22:05:13 -0500
Message-ID: <47351FE1.4000001@garzik.org>
Date: Fri, 09 Nov 2007 22:05:05 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Mark Lord <liml@rtr.ca>, Riki Oktarianto <rkoktarianto@gmail.com>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] Add quirk to set AHCI mode on ICH boards
References: <20071109020235.GA2031@ceren>	<20071109023129.GA25581@havoc.gtf.org>	<4733D421.7000505@rtr.ca>	<20071109034622.GB25581@havoc.gtf.org> <20071109120425.543971bf@the-village.bc.nu>
In-Reply-To: <20071109120425.543971bf@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Thu, 8 Nov 2007 22:46:22 -0500
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> On Thu, Nov 08, 2007 at 10:29:37PM -0500, Mark Lord wrote:
>>> And I might even privately patch my own kernels to map the ACHI BAR
>>> in the cases where the BIOS didn't...
>> The inability to do this in the general case is the main reason why
>> AHCI was not unconditionally enabled, even in IDE mode, when it was
>> originally added...  :/
> 
> We've done it all the time for various devices without problems (eg S3
> video cards). I'd like to see it go in - although perhaps attached to a
> force_ahci boot param initially

By forcing AHCI, your PATA devices will be inaccessible, in a common 
configuration.  It also means shuffling users from one driver to 
another, which induces breakage.

I was speaking wishfully.  Real life intrudes, alas.

	Jeff


