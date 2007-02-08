Return-Path: <linux-kernel-owner+w=401wt.eu-S1752422AbXBHSmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422AbXBHSmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 13:42:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbXBHSmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 13:42:12 -0500
Received: from c-69-254-139-13.hsd1.nm.comcast.net ([69.254.139.13]:52687 "EHLO
	deneb.dwf.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752422AbXBHSmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 13:42:11 -0500
X-Greylist: delayed 1463 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Feb 2007 13:42:11 EST
Message-Id: <200702081817.l18IHlbE027996@deneb.dwf.com>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Why can't I build a running Kernel?
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 08 Feb 2007 11:17:47 -0700
From: Reg Clemens <reg@dwf.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Why can't I build a running Kernel?
I have in the past, but since some time in the 2.6.19 series,
I have got the following series of errors. 
Same thing now with 2.6.20.

I build with:

    make xconfig

changing only the Processor type to Pentium4,
then I

    make bzImage
    make modules
    make modules_install
    make install

Fine everything builds, no errors.
I then try booting, and I get 4 or 5 lines and then

    Unable to access resume device (/dev/sda5)
    mount: could not find filesystem '/dev/root'
    < 4 more lines with setuproot and switchroot >
  
and then

    Kernel panic - not syncing: Attempting to kill init!

Sigh.
What has changed, what do I need to do to get this thing to boot?
-- 
                                        Reg.Clemens
                                        reg@dwf.com


