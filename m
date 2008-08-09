Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbYHIUPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbYHIUPT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 16:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYHIUPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 16:15:06 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:49477 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbYHIUPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 16:15:06 -0400
Message-ID: <489DFACC.6030009@keyaccess.nl>
Date: Sat, 09 Aug 2008 22:15:08 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Antonino Daplas <adaplas@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Framebuffer drivers that break the boot on systemswithout the hardware
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antonino.

At:

http://lkml.org/lkml/2008/8/1/96

Ingo Molnar posted a list of drivers he found to break the boot during 
testing of randconfig kernels and among them are a number of FB drivers:

   FB_CIRRUS
   FB_ASILIANT
   FB_VGA16
   FB_VESA
   FB_RADEON
   FB_CYBLA
   (and FB_VIRTUAL)

Looking at some of them there wouldn't seem to be too many very sensible 
options to avoid this at the individual driver level. Would you perhaps 
have an idea how to avoid the issue generically for these?

More of the drivers in that list will  be considered fine as is but I 
was fixing some of the old legacy ISA ones as ofcourse any driver not 
needing special avoidance treatment is one less to have to deal with.

The randconfig testing IS useful in finding bugs, so...

Rene.

