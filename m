Return-Path: <linux-kernel-owner+w=401wt.eu-S965366AbXBLUx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965366AbXBLUx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 15:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965385AbXBLUx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 15:53:29 -0500
Received: from smtpout06-01.prod.mesa1.secureserver.net ([64.202.165.224]:39206
	"HELO smtpout06-04.prod.mesa1.secureserver.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S965366AbXBLUx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 15:53:29 -0500
X-Greylist: delayed 742 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Feb 2007 15:53:28 EST
Message-ID: <45D0D09D.8010807@techmoninc.com>
Date: Mon, 12 Feb 2007 14:39:57 -0600
From: Andy Kennedy <akennedy@techmoninc.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Serial console issues.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For those of you who are on BusyBox's mailing list, you've already seen 
this -- I was sent here for help.

Specs:
Linux:  2.6.18
Bootloader:  SysLinux
Init:  BusyBox (ver 1.4.0) init.
Kernel command line: console=ttyS0,115200,n,8,1
System: VersaLogic 568 (STD80/STD32 Bus, i386 based computer)
Issue:  Booting on "System" I get perfect printk's to the serial 
console.  When the init takes over (from within an initrd), the console 
begins to miss characters.  I can still send write commands through the 
console, however, the output of these commands is garbled.  The really 
odd part is when the init releases control (is killed by Linux), or when 
a printk is issued, the console prints perfectly again.  The next really 
strange part about this is that changing "System" to my laptop -- no 
problems PERIOD. 

The BusyBox list directed me to LKML as this is a wider base of users 
that may have experienced the same problem and could provide me an answer.

Thanks in advance for the help (and sorry for asking such a non-related 
issue on the LKML),
Andy
