Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbXKLAWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbXKLAWh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 19:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbXKLAW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 19:22:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41428 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449AbXKLAW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 19:22:28 -0500
Message-ID: <47379CB7.6010404@zytor.com>
Date: Sun, 11 Nov 2007 16:22:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Matt Domsch <Matt_Domsch@dell.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Keith Chew <keith.chew@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCI card initialisation at boot
References: <20f65d530711110722k3d2bf658hb44ceaa036b9962c@mail.gmail.com> <20071111164644.7b2c743c@the-village.bc.nu> <20071111234313.GB15880@auslistsprd01.us.dell.com>
In-Reply-To: <20071111234313.GB15880@auslistsprd01.us.dell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Domsch wrote:
> On Sun, Nov 11, 2007 at 04:46:44PM +0000, Alan Cox wrote:
>> Linux by default uses the BIOS resource assignments. It doesn't know
>> where those came from other than "the BIOS".
> 
> Slightly tangential, but I'm starting to hear requests to have the OS
> re-assign resources when it might make better sense.  For example, if
> you have a graphics card with a 1GB memory allocation, the BIOS may
> assign it into address ranges below 4GB because it doesn't know
> if the OS will be 32-bit or 64-bit capable.  But, it would be
> beneficial to have it located above 4GB, and to fill in the (new) hole
> below 4GB with RAM.  Linux right now doesn't have a way to do this.
> It will assign resources for cards that the BIOS left unassigned, but
> won't intentionally move resources.
> 

Not really.  If the OS is 64-bit capable, it can just use the RAM above 
4 GB.

	-hpa
