Return-Path: <linux-kernel-owner+w=401wt.eu-S1752636AbXLIGOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbXLIGOS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 01:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbXLIGOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 01:14:05 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:17893 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbXLIGOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 01:14:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=organization:to:subject:user-agent:mime-version:content-disposition:date:message-id:content-type:content-transfer-encoding:from;
        b=PQxXPVJ/0cvJvwsL9DcPTIuGKmAhoPOHJgr0NacMsCmmS8wiQPolbk5p7I2OOd4ApxqFEVHNvMNTamK+FNhOCbgHVbRfgB/AVv+WkA3zdib35n5oaEDqjY7RhJIhoJwdnOqvcr4uSz2SSxSX83fgs0AY2MXRdFtcrviA3i02JlY=
Organization: Organization? Not detectable
To: linux-kernel@vger.kernel.org
Subject: usb regression in 2.6.24-rc4
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
Date: Sun, 9 Dec 2007 01:13:57 -0500
Message-Id: <200712090113.57805.gene.heskett@gmail.cm>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
From: Gene Heskett <gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings guys & gals;

This was sent about an hour ago to the usb-devel list also.
-------------
Just a few minutes ago I needed to make use of my scanner, an Epson 1250u.

Firing up xsane, the usual select the device menu window didn't show, and it 
went straight to my tv card as the only input device.

I couldn't recall the name of the tool that scans for scanners that's in the 
sane package, or should be, so I then did an lsusb, but got an empty result!

Unplugging the usb cable from the scanner, then reconnecting the usb cable got 
me the usual disconnect and connect messages in the log, but xsane still 
couldn't find it.

So I rebooted to 2.6.24-rc4 again, same result.  lsusb still gave an empty 
result.  The two kernels were generated from the same .config as far as I 
know.  The -rc3 .config was fed to a "make oldconfig" to make 
the -rc4 .config as is the usual practice.

So I then rebooted to 2.6.24-rc3, and it all works again.  I got the scanning 
done and the pix sent on their merry way.

Anybody have a suggestion of what to check, or maybe a patch to revert?  Or 
a .config option that needs to be enabled?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Nothing is impossible for the man who doesn't have to do it himself.
		-- A.H. Weiler
