Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbYFHSvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbYFHSvx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 14:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYFHSvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 14:51:44 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:8020 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbYFHSvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 14:51:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Sc4KWMcj6K/uDgfwIHSXd+4vZ4PiB85XZZ10vdO+ZNXe+mtMsY7JK24aAnG5iq1TKL
         dpgzfccC0fjUxtU3SAsBw3I4QYtq+MV9Bpi+f252fvlmTTRSvDuuRyMVI+T2CCQvngZo
         7Q03UiSIIL++beSG4diyppQqTTlDFNdj39/yE=
Message-ID: <dd18b0c30806081151q7895a930te5fd374e35471c7a@mail.gmail.com>
Date: Sun, 8 Jun 2008 18:51:42 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: BUG: unable to handle kernel paging request at f8dbf000 "isight_firmware"
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello; first I want to thank's for the acknowledgment "that really
touches me man",
Now on to the status with isight firmware, It seems The two modules
are loading uvcvideo and isight_firmware, but there not talking with
each other upon booting,
 under dmesg i see:

[   14.971002] firmware: requesting isight.fw
[   15.183152] usbcore: registered new interface driver isight_firmware

[   16.849152] usbcore: registered new interface driver uvcvideo

I've changed /etc/modules with the order of loading, but still same
results, usually to get it working I need to start the system, and
then once up and running
I need to rrmod uvcvideo, and isight_firmware, and then modprobe both,
and then reboot to have the two talk with each other.
Should I set something in /etc/udev/rules.d/* or is this something
else. Besides that once the two are working, everything is good.
regards;

-- 
Justin P. Mattock
