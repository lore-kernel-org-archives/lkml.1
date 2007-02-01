Return-Path: <linux-kernel-owner+w=401wt.eu-S1422916AbXBAXnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422916AbXBAXnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 18:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422917AbXBAXnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 18:43:31 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:57186 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422916AbXBAXna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 18:43:30 -0500
Date: Thu, 01 Feb 2007 17:37:12 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.16.16 Lost CD-ROM Drive
In-reply-to: <fa.Qe/B25xsBoYC29PSTYgHZvs0dwA@ifi.uio.no>
To: "Brian D. McGrew" <brian@visionpro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: jeremy@emperorlinux.com
Message-id: <45C279A8.9080501@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Qe/B25xsBoYC29PSTYgHZvs0dwA@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Brian D. McGrew wrote:
>> What am I missing to get the 2.6.16.16 kernel to see a SATA CD-ROM
> drive
>> in normal, non-legacy move?
> 
> Try booting 2.6.16 with the following options:
> 
> libata.atapi_enabled=1 ide0=noprobe ide1=noprobe
> -----
> 
> Still no go.  /dev/sda* is created for the hard drive but no CD-ROM and
> the same ATAPI error in dmesg.

If libata is built as a module, putting libata.atapi_enabled=1 on the 
kernel command line won't work. In that case, try putting

options libata atapi_enabled=1

in /etc/modprobe.conf. Of course if libata is being loaded from the 
initrd that may not work, in which case the easiest solution is likely 
to just build it into the kernel so that the kernel command line method 
will work.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

