Return-Path: <linux-kernel-owner+w=401wt.eu-S1763249AbXE2CHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763249AbXE2CHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 22:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbXE2CHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 22:07:32 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:7217 "EHLO
	outbound2-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753603AbXE2CHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 22:07:31 -0400
X-BigFish: V
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 209.50.91.134;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
Subject: =?utf-7?B?UkU6ICtBRnMtcGF0Y2grQUYwLSBBZGQgdGhlIGRldmljZSBJRHMgZg==?=
	=?utf-7?B?b3IgQU1EL0FUSSBTQjcwMA==?=
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-7"
Content-Transfer-Encoding: 7bit
Date: Tue, 29 May 2007 09:55:09 +0800
Message-ID: <FFECF24D2A7F6D418B9511AF6F35860201B36B3E@shacnexch2.atitech.com>
In-Reply-To: <200705282216.59611.bzolnier@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: =?utf-7?B?K0FGcy1wYXRjaCtBRjAtIEFkZCB0aGUgZGV2aWNlIElEcyBmb3IgQQ==?=
	=?utf-7?B?TUQvQVRJIFNCNzAw?=
Thread-Index: AcehbMTkI7haQG2ATR
From: "Henry Su" <henry.su@amd.com>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Jeff Garzik" <jeff@garzik.org>
Cc: <alan@lxorguk.ukuu.org.uk>, <greg@kroah.com>,
       <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
       <xiaosuzi520@hotmail.com>
X-OriginalArrivalTime: 29 May 2007 01:55:14.0202 (UTC) FILETIME=[66027FA0:01C7A194]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
Since I am a junior linux developing engineer, I really appreciate that you tell me these informations,
Thanks for your help+ACE-

Brs,
Henry

-----Original Message-----
From: Bartlomiej Zolnierkiewicz +AFs-mailto:bzolnier+AEA-gmail.com+AF0- 
Sent: Tuesday, May 29, 2007 4:17 AM
To: Jeff Garzik
Cc: Henry Su+ADs- alan+AEA-lxorguk.ukuu.org.uk+ADs- greg+AEA-kroah.com+ADs- linux-kernel+AEA-vger.kernel.org+ADs- linux-ide+AEA-vger.kernel.org+ADs- xiaosuzi520+AEA-hotmail.com
Subject: Re: +AFs-patch+AF0- Add the device IDs for AMD/ATI SB700


Hi,

Sorry for the late reply and thanks to Jeff for stepping in. :)

Since Jeff covered both status of your patches and administrative issues
I would only like to add one small hint for people adding support for
multi-function PCI chipsets (with multiple PCI device IDs):

It makes sense to put addition of +AF8-all+AF8- new PCI IDs into the first patch
of the series and send it to PCI Maintainer (Hi Greg).  This should make
all other patches from the series independent of each other (in the usual
case I'm not talking about all crazy scenarios here).  After the patch
with PCI IDs gets applied upstream you may now send all other patches to
the respective maintainers without worrying about inter-patch dependencies
and without maintainers worrying about your patches not applying cleanly.

IIRC Intely guys are using this process when adding support for their new
chipsets and it works smoothly.

+AFs- Yep, this process is the exception from the general +ACI-patch shouldn't add
  unused code+ACI- rule but the amount of +AF8-temporarily+AF8- unused stuff is +AF8-minimal+AF8-
  and doing it this way saves a lot of time for all parties involved. +AF0-

PS Greg/Jeff If I'm totally wrong on this please correct me...

Thanks,
Bart

On Friday 25 May 2007, Jeff Garzik wrote:
+AD4- Henry Su wrote:
+AD4- +AD4- I check the latest kernel source code with git, and find out that the
+AD4- +AD4- SMBus patch has not been applied yet,  
+AD4- 
+AD4- Correct.  When you don't see a patch in the upstream git tree 
+AD4- git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git 
+AD4- then the next step is consult the MAINTAINERS file, and determine to 
+AD4- whom you should send a follow-up patch, or simply contact about the 
+AD4- status of a patch you just sent.  In this case, SMBus is in drivers/i2c 
+AD4- sub-directory, which leads us to find in MAINTAINERS,
+AD4- 
+AD4- I2C SUBSYSTEM
+AD4- P:      Jean Delvare
+AD4- M:      khali+AEA-linux-fr.org
+AD4- L:      i2c+AEA-lm-sensors.org
+AD4- T:      quilt http://khali.linux-fr.org/devel/linux-2.6/jdelvare-i2c/
+AD4- S:      Maintained
+AD4- 
+AD4- That tells us the maintainer of the subsystem, and also (+ACI-T:+ACI-) an 
+AD4- external reference (a tree) to where the maintainer posts accepted 
+AD4- patches, prior to sending them upstream.
+AD4- 
+AD4- So for SMBus, you should make sure your SMBus changes appear in Jean 
+AD4- Delvare's quilt tree.  If they do not, create a new patch and send it to 
+AD4- Jean and CC i2c+AEA-lm-sensors.org and linux-kernel+AEA-vger.kernel.org.
+AD4- 
+AD4- 
+AD4- +AD4- and the patch for IDE  has not been  applied completely.one more device
+AD4- +AD4- id should be added to pata+AF8-atiixp.c, 
+AD4- +AD4- l list the patch as following, or you can fetch it from the attached file,
+AD4- +AD4- could you please apply this for me?  
+AD4- 
+AD4- Actually it has been applied -- the part that I maintain (drivers/ata/+ACo-) 
+AD4- is currently stored in a secondary tree, as described above.  Your patch 
+AD4- has been stored on the 'upstream' branch of 
+AD4- git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
+AD4- 
+AD4- Currently, the upstream Linux kernel is only accepting bug fixes.  I 
+AD4- merge ATA bug fixes (and sometimes simple PCI ID additions) into 
+AD4- libata-dev.git+ACM-upstream-fixes during this phase of development.  These 
+AD4- changes are sent upstream in 24-48 hours, to ensure that they will be 
+AD4- included in the next release (kernel 2.6.22).
+AD4- 
+AD4- All other ATA changes are merged into libata-dev.git+ACM-upstream.  When 
+AD4- Linus releases kernel 2.6.22, the +ACI-merge window+ACI- opens, allowing 
+AD4- non-bug-fix changes to be submitted upstream.  When the merge window 
+AD4- opens, I submit everything in libata-dev.git+ACM-upstream to Linus and 
+AD4- Andrew Morton for inclusion in the official upstream kernel tree.
+AD4- 
+AD4- That is our development process in a nutshell.
+AD4- 
+AD4- The kernel development process is conducted entirely via email, so you 
+AD4- see why it is so important to learn how to email patches in the proper 
+AD4- format.
+AD4- 
+AD4- 	Jeff



