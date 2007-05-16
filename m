Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbXEPPIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbXEPPIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 11:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbXEPPIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 11:08:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:36174 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754435AbXEPPId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 11:08:33 -0400
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       viro@zeniv.linux.org.uk, kenchen@google.com
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 16 May 2007 17:08:31 +0200
From: "Uwe Bugla" <uwe.bugla@gmx.de>
Message-ID: <20070516150831.292350@gmx.net>
MIME-Version: 1.0
Subject: bug in 2.6.22-rc1: loop devices limited to one single device
To: linux-kernel@vger.kernel.org
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+t4LQhWjCt4Ik8swvGpINd4X2/cUGyaCk7WPAXoS
 mZsshqcXcIs49qlVx/XgRkuJih/r7dVh/0lQ== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: WCh4clE6TXsuS3fqHmQ5snNCRzdyMsMa
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The patch against loop.c is neither a fix, nor does it create
loop devices on demand:

Facts are instead, at least on my machine:

The number of available loop devices is reduced from 8 (conventional
standard of preceding 2.6 kernels) to 1.

The consequence is: If you have to mount more than one single iso-image with
the loop parameter you are receiving the following message during system boot:

"mount: could not find any free loop device"

Regards

Uwe

-- 
GMX FreeMail: 1 GB Postfach, 5 E-Mail-Adressen, 10 Free SMS.
Alle Infos und kostenlose Anmeldung: http://www.gmx.net/de/go/freemail
