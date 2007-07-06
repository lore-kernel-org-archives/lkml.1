Return-Path: <linux-kernel-owner+w=401wt.eu-S1762930AbXGFKXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762930AbXGFKXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 06:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbXGFKXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 06:23:08 -0400
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:53148 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763665AbXGFKXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 06:23:06 -0400
X-Greylist: delayed 2070 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jul 2007 06:23:06 EDT
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <468D7034.7060107@whitby.id.au>
References: <20070703185116.59c8f5f5@the-village.bc.nu> <468D7034.7060107@whitby.id.au>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <9F3D802E-9A32-4703-98B8-C8A4142C9BF6@cam.ac.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org
Content-Transfer-Encoding: 7bit
From: Michael-Luke Jones <mlj28@cam.ac.uk>
Subject: Re: Libata PATA status (pata_artop)
Date: Fri, 6 Jul 2007 10:48:22 +0100
To: Rod Whitby <rod@whitby.id.au>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 Jul 2007, at 23:27, Rod Whitby wrote:

> Alan Cox wrote:
>> Chipsets
>> ========
>> ARTOP
>> 	No reports, but nobody appears to be using one
>
> The NSLU2-Linux project (http://www.nslu2-linux.org) relies on the
> pata-artop driver for the arm/ixp4xx-based Iomega NAS100d and D-Link
> DSM-G600 NAS devices (both of which are supported in recent mainline
> kernels).
>
> Latest kernels (2.6.22-rc5 is the latest we've tested) have no  
> reported
> problems with pata-artop.  We have a handful of people (including
> myself) who we know are using 2.6.22-rc5 on those devices and are
> booting from the internal drive using the pata-artop driver.

Though we have no reported problems, we are carrying a local patch to  
the pata_artop driver:

http://trac.nslu2-linux.org/kernel/browser/trunk/patches/2.6.22/15- 
nas100d-pata-artop-single-port.patch

This used to be because of a long delay when probing the non-existent  
second ATA port on these embedded ARM devices, but the comment in the  
patch has since been updated suggesting some negative interaction  
with USB (??).

I don't have this machine so can't comment further on this issue,

M-L

