Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbYFJR6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbYFJR6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbYFJR6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:58:12 -0400
Received: from smtpout.karoo.kcom.com ([212.50.160.34]:50791 "EHLO
	smtpout.karoo.kcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbYFJR6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:58:11 -0400
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jun 2008 13:58:10 EDT
X-IronPort-AV: E=Sophos;i="4.27,618,1204502400"; 
   d="scan'208";a="1574883"
Date: Tue, 10 Jun 2008 18:48:20 +0100 (BST)
From: Keith Roberts <keith@karsites.net>
To: linux-kernel@vger.kernel.org
Subject: Problems with edd
Message-ID: <alpine.LFD.1.10.0806101840510.6356@www.karsites.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all. I have a problem with trying to boot from a Fedora 9 
installation CD-R. It works on another machine, so the disk 
is OK. I guess if anyone knows the answer then it will be 
found here on the kernel developers list.

When trying to boot from a CD-R installation disk, on my 
Advent 6415 laptop I get the following:

Welcome to Fedora 9! [the installer splash screen]

  I then click on either:

  Install or upgrade an existing system
  [or]
  Install or upgrade an existing system (text mode)

  [both give me the same following error]

  Loading vmlinuz........................................... 
..............

  Loading initrd.img........................................ 
.................
  ...............ready.
  Probing EDD (edd=off to disable)... ok
  vmlinuz: attempted DOS system call
  boot:

  If I hit return now, the machine goes back to the 'Welcome 
to Fedora 9!' splash screen.

I have edited the kernel parameters at the spalsh screen and 
tried:

edd=skipmbr edd=off

All that does is not display the line:
  Probing EDD (edd=off to disable)... ok

The installation still hangs at the boot: prompt.

Has anyone come across the behaviour before please?

Is there any way I can get my laptop to boot from this 
media, maybe by passing some undocumented kernel parameters?

Kind Regards,

Keith Roberts
