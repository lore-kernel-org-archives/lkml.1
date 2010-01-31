Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918Ab0AaAgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab0AaAgL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 19:36:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202Ab0AaAgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 19:36:10 -0500
Received: from cantor.suse.de ([195.135.220.2]:47436 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab0AaAgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 19:36:09 -0500
Date: Sat, 30 Jan 2010 16:33:44 -0800
From: Greg KH <gregkh@suse.de>
To: Christian Hesse <mail@earthworm.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Samsung N220 backlight support
Message-ID: <20100131003344.GA24083@suse.de>
References: <201001301706.18245.mail@earthworm.de>
 <20100130162857.GA26029@suse.de>
 <201001301937.34834.mail@earthworm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001301937.34834.mail@earthworm.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 30, 2010 at 07:37:34PM +0100, Christian Hesse wrote:
> Oh, did not notice it was included in mainline already.
> I applied the attached patch. Insmod now gives:
> 
> insmod: error inserting 'samsung-laptop.ko': -1 Invalid parameters
> 
> and the logs contain the following:
> 
> kernel: samsung_laptop: found laptop model 'N220'
> kernel: This computer does not support SABI
> 
> What is this SABI and SECLINUX thing about?

It is the BIOS interface that the kernel talks to.

> Do you have a link to any more information?

No, I don't know of any public information on this interface, sorry.

> Is it possible that the N220 does not have this?

Yes, it does not.

> The N220 uses a Pine Train platform (featuring N450 with 64bit support), so I 
> installed x86_64 to the device.
> 
> I would be glad to test whatever you give me.

I'm sorry, but I am not allowed to make any changes to the driver to
support other laptops at this time, but I can accept patches written by
others.

Yeah, it sucks, sorry.

greg k-h
