Return-Path: <linux-kernel-owner+w=401wt.eu-S1758742AbYDJWmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742AbYDJWmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 18:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbYDJWl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 18:41:59 -0400
Received: from web26104.mail.ukl.yahoo.com ([217.146.182.145]:20716 "HELO
	web26104.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750975AbYDJWl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 18:41:59 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Apr 2008 18:41:58 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=FFq+Ww1rv8Kh7yXE9RztmT9/nepgNtvLZDTKd+naKn5tC/5I03xHNWN0VEj+spX3pzNMSy2QK6EJt0xRPY7Db6+Cn98MLmEq4HIu5n+FoXbEkNoGVBqku3LAhc6XXtVxOJ96L7HGHobWVWerGJjzkMzPJlmQh4xVEeVj3BfTYR8=;
X-YMail-OSG: vpORI4sVM1lxHUfTcGSrpnsEwevNkTkex4GeGp4GJsFqVsLDcEGmuKW5tsGM0KKhe9HuXraP0AiK0iU07131KbqXIpT_AG1ARwQ6tzQlB4Q4x47Ssr2cI4sgwOM-
Date: Fri, 11 Apr 2008 00:35:15 +0200 (CEST)
From: linuxcbon <linuxcbon@yahoo.fr>
Subject: Question about Creative Webcam Pro PD1030 ? Bug ?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <69486.72717.qm@web26104.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

sorry if this is not the correct mail list.

I am not sure if this is a bug, if someone can help me ?

I got a Creative Webcam Pro PD1030.

Drivers are loaded :
# dmesg |grep ov511
drivers/media/video/ov511.c: USB OV511+ video device found
drivers/media/video/ov511.c: model: Creative Labs WebCam 3
drivers/media/video/ov511.c: Sensor is an OV7620AE
drivers/media/video/ov511.c: Enabling 511+/7620AE workaround
drivers/media/video/ov511.c: Device at usb-0000:00:02.0-2 registered to
minor 0
usbcore: registered new interface driver ov511
drivers/media/video/ov511.c: v1.64 for Linux 2.5 : ov511 USB Camera Driver


lsmod gives :
ov511                  77072  0 
squashfs               46856  0 
compat_ioctl32          1408  1 ov511
videodev               27904  1 ov511
v4l2_common            16896  1 videodev
v4l1_compat            14596  1 videodev
usbcore               127128  6 usb_storage,usblp,ov511,ehci_hcd,ohci_hcd

# uname -a
Linux puppypc 2.6.21.7 #1 Sun Feb 24 10:22:08 GMT-8 2008 i686 GNU/Linux


I try for testing
cat /dev/video > video.avi

I got : 

cat: /dev/video*** glibc detected *** cat: free(): invalid next size
(fast): 0x08050ab8 ***
======= Backtrace: =========
/lib/libc.so.6[0xb7f4140e]
/lib/libc.so.6(cfree+0xa9)[0xb7f42bdd]
/lib/libc.so.6[0xb7f1088c]
/lib/libc.so.6[0xb7f0f0ef]
/lib/libc.so.6[0xb7f0edcf]
/lib/libc.so.6(dcgettext+0x24)[0xb7f0e030]
/lib/libc.so.6(__strerror_r+0xc9)[0xb7f46b19]
/lib/libc.so.6[0xb7f89d37]
/lib/libc.so.6(error+0x89)[0xb7f89f38]
cat[0x8049321]
/lib/libc.so.6(__libc_start_main+0x12e)[0xb7f0420e]
cat[0x8048c5d]
======= Memory map: ========
08048000-0804c000 r-xp 00000000 16:05 304622     /bin/cat
0804c000-0804d000 rw-p 00003000 16:05 304622     /bin/cat
0804d000-0806e000 rw-p 0804d000 00:00 0          [heap]
b7d00000-b7d21000 rw-p b7d00000 00:00 0 
b7d21000-b7e00000 ---p b7d21000 00:00 0 
b7ea1000-b7eaa000 r-xp 00000000 16:05 502230     /usr/lib/libgcc_s.so.1
b7eaa000-b7eab000 rw-p 00008000 16:05 502230     /usr/lib/libgcc_s.so.1
b7eab000-b7ede000 r--p 00000000 16:05 498627    
/usr/lib/locale/en_US/LC_CTYPE
b7ede000-b7edf000 r--p 00000000 16:05 498634    
/usr/lib/locale/en_US/LC_NUMERIC
b7edf000-b7ee0000 r--p 00000000 16:05 498637    
/usr/lib/locale/en_US/LC_TIME
b7ee0000-b7ee5000 r--p 00000000 16:05 498626    
/usr/lib/locale/en_US/LC_COLLATE
b7ee5000-b7ee6000 r--p 00000000 16:05 498632    
/usr/lib/locale/en_US/LC_MONETARY
b7ee6000-b7ee7000 r--p 00000000 16:05 498631    
/usr/lib/locale/en_US/LC_MESSAGES/SYS_LC_MESSAGES
b7ee7000-b7ee8000 r--p 00000000 16:05 498635    
/usr/lib/locale/en_US/LC_PAPER
b7ee8000-b7ee9000 r--p 00000000 16:05 498633    
/usr/lib/locale/en_US/LC_NAME
b7ee9000-b7eea000 r--p 00000000 16:05 498625    
/usr/lib/locale/en_US/LC_ADDRESS
b7eea000-b7eeb000 r--p 00000000 16:05 498636    
/usr/lib/locale/en_US/LC_TELEPHONE
b7eeb000-b7eec000 r--p 00000000 16:05 498629    
/usr/lib/locale/en_US/LC_MEASUREMENT
b7eec000-b7eed000 r--p 00000000 16:05 498628    
/usr/lib/locale/en_US/LC_IDENTIFICATION
b7eed000-b7eee000 rw-p b7eed000 00:00 0 
b7eee000-b7fe3000 r-xp 00000000 16:05 16065      /lib/libc-2.6.1.so
b7fe3000-b7fe4000 r--p 000f5000 16:05 16065      /lib/libc-2.6.1.so
b7fe4000-b7fe6000 rw-p 000f6000 16:05 16065      /lib/libc-2.6.1.so
b7fe6000-b7fea000 rw-p b7fe6000 00:00 0 
b7fea000-b7fff000 r-xp 00000000 16:05 16055      /lib/ld-2.6.1.so
b7fff000-b8001000 rw-p 00014000 16:05 16055      /lib/ld-2.6.1.so
bf808000-bf81e000 rw-p bf808000 00:00 0          [stack]
ffffe000-fffff000 r-xp 00000000 00:00 0          [vdso]
Aborted


I also got problems to use webcam with skype etc.
Can you help find the origin of the bug ?

Thanks very much.

Cheers, linuxcbon




      _____________________________________________________________________________ 
Envoyez avec Yahoo! Mail. Une boite mail plus intelligente http://mail.yahoo.fr
