Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbYDIUxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbYDIUxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 16:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756930AbYDIUxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 16:53:38 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:44613 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbYDIUxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 16:53:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=cg+5rzdSDC5IGIoMPwDiLjjzzt1+Ox4JODz7yjM1lSNr4oUb2ieKoLWV0+PQWZL/azWpM71/+jeT6qYKKv0K93PMBboYTuhGvjIJHAs7/E9GUtEWfY4wxIGdK7zl2xzd4mp9Y0GMvaYboFxK9JoLrGqCBUpJwTmCjVCwhNzaaFk=
Message-ID: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>
Date: Wed, 9 Apr 2008 22:53:36 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Disk geometry from /sys
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to know the geometry of my hard disk from a bash script
and that's the reason I'm looking in /sys. The reason is that I'd like
to figure out the size of a cylinder without doing a
ioctl(bdev, HDIO_GETGEO, &geo)

Unfortunately I can't find anything useful and this is certainly a sign
that I'm doing something wrong.

Or maybe can I simply assume from my script that the geometry
is always heads=255 and the number of sectors per track is 63 for all
disks.

Looking at parted(8) source code, I  can find this:

/* The GETGEO ioctl is no longer useful (as of linux 2.6.x).  We could
 * still use it in 2.4.x, but this is contentious.  Perhaps we should
 * move to EDD. */

Could anybody give me some advices ?
-- 
Francis
