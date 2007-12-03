Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbXLCUDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbXLCUDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 15:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbXLCUDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 15:03:09 -0500
Received: from mx12.go2.pl ([193.17.41.142]:56046 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753079AbXLCUDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 15:03:08 -0500
X-Greylist: delayed 20052 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Dec 2007 15:03:05 EST
Message-ID: <475460EA.4050606@o2.pl>
Date: Mon, 03 Dec 2007 21:02:50 +0100
From: Warpme <warpme@o2.pl>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
Subject: S3 resume stability problems
Content-Type: multipart/mixed;
 boundary="------------020401000900000109080902"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020401000900000109080902
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi *

I'm setting up 2 appliances based on AMD x2 4400 CPU and Nvidia Mobos: 
ASUS M2NPV-VM (6150 based) and Abit AN-M2HD (7050 based). Kernel is 
2.6.23.9.

My issue is stability of S3 resume:
-on ASUS it hangs every 3-10 try and it not depends on maxcpus setting.
-on Abit also it hangs every 3-10 try, but with maxcpus=1 is stable.

It is not depending on enabled HW on mobos - even with all HW disabled 
in BIOS S3, resume is still unstable.

Observing resume process I didn't see any errors in syslog. Also when 
resume hangs it hangs always with still lightning CapsLock keyb led 
(keyb is not reacting on CapsLock pressing) -> it leads me that it isn't 
video issue.

As Abit with maxcpus=1 is working OK - it hints me that resume issue is 
related to non-booting processor initialization.

Do somebody can help me investigate problem ?

br


--------------020401000900000109080902
Content-Type: text/x-vcard; charset=utf-8;
 name="warpme.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="warpme.vcf"

begin:vcard
fn:Warpme
n:;Warpme
email;internet:warpme@o2.pl
version:2.1
end:vcard


--------------020401000900000109080902--
