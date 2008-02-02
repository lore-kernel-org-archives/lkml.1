Return-Path: <linux-kernel-owner+w=401wt.eu-S1764845AbYBBPqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764845AbYBBPqW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 10:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756303AbYBBPqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 10:46:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:3504 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbYBBPqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 10:46:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=TtXodQWcx2Osm+TYSS3i6tsAxt06HquPnIzIO/6SzpPoI1bFplr4uGB3jdoO6bMv9GimmsHkW7gdqGgYaVl3jv0e4CgCScKCnsJYMvyOyA6hTr9Of/U6BDePx3Y6JtjeBIvob/eWOO/qLdBCDPMf8Oc8eoT/Mpe9uZu0TQuj2fA=
Message-ID: <34bc550b0802020746r7f89ca98me2fd4d93dcc7defd@mail.gmail.com>
Date: Sat, 2 Feb 2008 21:16:11 +0530
From: "Sam K. Raju" <ujarkmas@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Unable to boot kernel 2.6.24 (lvm unable to find VolGroup00)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

As soon as the new kernel released I decided to give it a try. I had
RedHat Enterprise Linux 4 with two kernel, 2.6.9-55.ELsmp & 2.6.17.3.
I downloaded the new kernel 2.6.24, configured and installed. But
while booting, Kernel panic giving the following error:

VFS: Cannot open root device "Volgroup00/LogVol00" or unknown-block(0,0)
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)

I searched on the linux forum and found that I hadn't added the
multiple device support (RAID & LVM) and RAM disk support. So I added
them as module and again compiled the kernel but while booting it is
now giving the following error:

Activating logical volumes
Volume group "VolGroup00" not found
ERROR: /bin/lvm exited abnormally! (pid 421)

I was using a custom compiled kernel 2.6.17.3 earlier. I even tried to
compile the 2.6.24 kernel with the .config file of 2.6.17.3 kernel
(may be a foolish idea) but it didn't worked too. I got the same error
message as above.

I even tried 'make defconfig' for configuring the kernel but it didn't
worked either.

Can anybody help me, what I am missing this time. :-(

Thanks,
Sam
