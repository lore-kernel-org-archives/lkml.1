Return-Path: <linux-kernel-owner+w=401wt.eu-S1762200AbYBNS4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762200AbYBNS4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756784AbYBNS4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:56:00 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:48349 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783AbYBNSz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:55:59 -0500
Date: Thu, 14 Feb 2008 12:55:21 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Handshaking on USB serial devices
In-reply-to: <20080214163143.0915b44c@core>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Newall <davidn@davidnewall.com>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802141255.22048.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <47B30291.2040905@davidnewall.com>
 <200802141116.14722.gene.heskett@gmail.com> <20080214163143.0915b44c@core>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2008, Alan Cox wrote:
>O> believe at several second intervals.  I can cut those messages to about
>
>> weekly by using an FDTI adaptor in its place, or I can stop them entirely
>> if
>
>Sorry don't see the connection between the two stories ?
>
>Alan

The connection is that windows people don't see those errors, linux folks do. 
I believe, but don't know how to use the tools to verify it, that the first 
byte of a packet is being thrown away about .1% of the time for the pl2303, 
but I'm not sure if the FTDI driver still suffers from a similar rash.  I 
have only one such FTDI adapter in the system atm, and its in series with 
manual heyu commands only, so it doesn't get regularly exercised.  I figure 
it will do the least damage there.  The pl2303's are all hanging on a peg 
waiting for emergency use only, they were just too much trouble when they 
miss-fire and the system issues -wall warnings several times per hour.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The revolution will not be televised.
