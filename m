Return-Path: <linux-kernel-owner+w=401wt.eu-S1759984AbYEYUPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbYEYUPh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 16:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbYEYUP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 16:15:27 -0400
Received: from mail1.ugh.no ([80.239.42.168]:48356 "EHLO mail1.ugh.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757509AbYEYUP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 16:15:26 -0400
X-Greylist: delayed 1921 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 May 2008 16:15:25 EDT
Message-ID: <4839C160.6010409@tomt.net>
Date: Sun, 25 May 2008 21:43:28 +0200
From: Andre Tomt <andre@tomt.net>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Mark Lord <liml@rtr.ca>, Jeff Garzik <jeff@garzik.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: Marvell 88SX7042 [4 Port SATA PCI-Express x4] Support/Questions
References: <alpine.DEB.1.10.0805250757550.18572@p34.internal.lan> <4839A63E.4050409@rtr.ca>
In-Reply-To: <4839A63E.4050409@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Justin Piszcz wrote:
>> If one bought enough of these, one could possibly achieve speeds in 
>> excess(!) of 1 gigabyte/second with enough drives and SW RAID in Linux.
>> Does anyone have such a card? I would be interested if it could 
>> sustain the maximum rate from each disk without any contention.
> ..
> 
> Sure, if the bus and memory are fast enough.  You'll hit the Linux/libata
> transactions/sec limit at some point, but I don't know what that is.

I'm seeing 800MB/s on ICH8/9R class chipsets on concurrent non-raid I/O, 
however that's the limit of the PCIe bus used between the ICH (south, 
IO) and the MCH (north, memory/cpu/video-pcie hub). ICH10 is supposed to 
double that by moving up to PCI-e 2.0 on that link AFAIK.

> Eg. Here's a 4X (I think) card in my PCIe video slot:

Ah, of course making use of the video PCIe slot by putting as many ports 
as you can on it will improve the situation somewhat as its generally 
connected to the MCH directly. (mm, any plain/non-raid 88SX7xxx PCIe 
cards with 8 ports available?)
