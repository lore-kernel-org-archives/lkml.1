Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbZEGHoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbZEGHoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 03:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbZEGHnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 03:43:49 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:48196 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbZEGHnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 03:43:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=gSXud+Pr3f6oxRotWBS4ft8u2y6YgMXQr0TVGvnSb+qlrforjethIh5E/u9d1j/gAR
         GRu50BWbi6myt0kzrl/gb3lqf/wL+bP64cGR9DdNivzmzIKkdfOV0DrgxyjejqjI/rhn
         mvPTh9bWgfciTwhp7Vkv9tC9lW1+Chfk+0q/w=
Subject: Linux ATA Trim support
From: Clive Wagenaar <clivewagenaar@gmail.com>
Reply-To: clivewagenaar@gmail.com
To: kernel-team@lists.ubuntu.com
Cc: lkml <linux-kernel@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
       Chris Mason <chris.mason@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       tim gardner <tim.gardner@canonical.com>
Content-Type: text/plain
Date: Thu, 07 May 2009 08:43:43 +0100
Message-Id: <1241682223.3759.67.camel@9200>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ubuntu kernel Devs

Could you please advise your thoughts on ATA Trim support in the 9.10,
Karmic, kernel for SSD drives.
I am not very clued in as to how far the patches have gotten in the
mainline kernel of Linus, but I do believe people are working on it and
it is close now.

I recently bought a OCZ Vertex 120G SSD drive, as they are the first SSD
manufacturer to be publicly building tools for ATA trim and have
indicated that they will have experimental ATA trim support for Linux in
their next firmware update expected with 2 weeks.
(Bootchart has 9.04 Juanty booting in 10 seconds off the single ssd of
OCZ)

As Windows Vista and 7 do not have ATA trim support yet, they have built
a exe tool that can be run by Windows uses that trims the SSD, so far it
works reliably on 32 bit versions of windows. linux uses cant use this
tool on EXT2/3/4 etc FS from within windows, so a native solution in the
kernel is the best way to go for Linux.

OCZ appear to be very proactive with support for ATA Trim, as this is
VERY important on SSD drives if one does not periodically want to
re-flash ones drive and then restore a image/re-install.

Some info on trim:
http://www.anandtech.com/storage/showdoc.aspx?i=3531&p=10

Please note that this Trim issue affects all SDD including that ones
used by Theodore Ts'o and Linus himself. (Intel X25-M)
Once the drive has had data written to most its 'sectors', write speed
will drop off drastically and until we have ata trim the only solution
is to re-flash the drive.

I am happy to re-flash my drive periodically, but for our Ubuntu for
humans, it will be great to have ATA trim in Karmic natively.

I do know the standard is still being finalized, but OCZ are being
proactive, the mainline kernel guys are too, so I hoping Ubuntu can be
too.


If any one has PPA kernels or Linux trim tools that they need me to test
on my OCZ drive, please do not hesitate to ask, I am more than willing
to beta test this ATA trim under Linux.
(I went for the OCZ vertex vs X25-M of Intel, due to the fact that OCZ
are proactive in their forums and incorporating user feedback into their
firmware, plus actively working on ATA trim, for both Windows and Linux)


Thanks for your time

-- 
clivewagenaar@gmail.com

System Powered by:
Ubuntu/Debian/Gnu/Linux
Distro: Jaunty 9.04
Kernel: 2.6.30-rc4-generic
File System: Ext4
Gnu+Linux user #419390
Ubuntu user #1072

