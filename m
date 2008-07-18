Return-Path: <linux-kernel-owner+w=401wt.eu-S1760866AbYGRBCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760866AbYGRBCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 21:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756549AbYGRBCC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 21:02:02 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:18841 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755578AbYGRBCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 21:02:01 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=dJlek8v6tykI2SpLzkgA:9 a=piFrBNYU4owme_J1yRgA:7 a=2NkFVsG0R9bCYcy8sycMz8zpPnIA:4
Message-ID: <487FEB85.8050809@shaw.ca>
Date: Thu, 17 Jul 2008 19:01:57 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Thomas Lucaw <aj881@chebucto.ns.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: ide-cd or ide-scsi dmesg contradiction
References: <fa.gdHId1md+1HIxZ5QOtsPlKx7Ijo@ifi.uio.no>
In-Reply-To: <fa.gdHId1md+1HIxZ5QOtsPlKx7Ijo@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Lucaw wrote:
> Hi, for some time I've noticed
> 
> giving the cmdline (to kernel at boot) "hdd=ide-scsi ..." I get
> 
> 	ide-scsi is deprecated for cd burning! Use ide-cd and give dev=/dev/hdX as device
> 
> then changing to the suggested "hdd=ide-cd ..." I get

That's not what it's suggesting (at least I don't think it is), if you 
remove the option entirely then ide-cd will bind to the device.

> 
> 	ide_setup: hdc=ide-cd -- OBSOLETE OPTION, WILL BE REMOVED SOON!
> 
> Rather illogical to me :-)
> 
> I guess neither should be used, I can make my cdrom and dvd devices work 
> without ok.
> 
> kernel 2.6.26
