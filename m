Return-Path: <linux-kernel-owner+w=401wt.eu-S1765924AbXIMTyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765924AbXIMTyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 15:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbXIMTyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 15:54:31 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34442 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757109AbXIMTya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 15:54:30 -0400
Message-ID: <46E99572.7080400@garzik.org>
Date: Thu, 13 Sep 2007 15:54:26 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Jon Ivar Rykkelid <jonry@pvv.org>
CC: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv issues with MCP51 SATA controller
References: <46E8EABF.3060409@pvv.org> <46E94728.9050509@garzik.org> <46E951C6.1000403@pvv.org> <46E953D7.5070305@gmail.com> <46E97AFF.30202@pvv.org> <46E98ED1.8070109@pvv.org>
In-Reply-To: <46E98ED1.8070109@pvv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Ivar Rykkelid wrote:
> Hi,
> 
> I now tested with the adma=0 option, but if anything I got a crash 
> quicker than before. Same error message started coming in, but this time 
> the system hung before I was able to capture the log as well (but I saw 
> the error, and it was the same as before, except that this time it was 
> the ata3-channel that first started acting up..) - To remind you all 
> what this is about, I have reattached the log that I originally captured...

Sounds like a hardware problem, since disabling ADMA is generally the 
cure-all we use -- it appears to stress the hardware less.

	Jeff



