Return-Path: <linux-kernel-owner+w=401wt.eu-S1764331AbYBNUS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764331AbYBNUS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761051AbYBNUSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:18:17 -0500
Received: from vms040pub.verizon.net ([206.46.252.40]:55476 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760926AbYBNUSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:18:16 -0500
Date: Thu, 14 Feb 2008 15:04:41 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Handshaking on USB serial devices
In-reply-to: <20080214193731.3c36acb0@core>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Newall <davidn@davidnewall.com>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802141504.41991.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <47B30291.2040905@davidnewall.com>
 <200802141255.22048.gene.heskett@gmail.com> <20080214193731.3c36acb0@core>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2008, Alan Cox wrote:
>> byte of a packet is being thrown away about .1% of the time for the
>> pl2303, but I'm not sure if the FTDI driver still suffers from a similar
>> rash.  I
>
>A 20 byte low speed message is too small for flow control to account for
>it.

Where then could the first byte go?  Note I'm not fussing about flow controls 
per sei, so the subject line maybe needs to be adjusted, but they obviously 
work well enough that a multimegabyte transfer to my printer works very well, 
but about usb trying to entirely replace serial here.  There does seem to be 
a problem but I'm not 100% positive where it is in the chain of a usb packets 
travels.  What I've observed, with hidraw I think it was, is that the 
first 'wake up' byte incoming didn't seem to be there.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Whenever people agree with me I always feel I must be wrong.
		-- Oscar Wilde
