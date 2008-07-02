Return-Path: <linux-kernel-owner+w=401wt.eu-S1758463AbYGBPHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463AbYGBPHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 11:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757884AbYGBPHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 11:07:17 -0400
Received: from smtp-01.oit.duke.edu ([152.3.174.14]:53712 "EHLO smtp.duke.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757389AbYGBPHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 11:07:14 -0400
X-Greylist: delayed 722 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jul 2008 11:07:14 EDT
Date: Wed, 2 Jul 2008 10:55:10 -0400 (EDT)
From: Rann Bar-On <rb6@duke.edu>
X-X-Sender: rann@localhost
Reply-To: rb6@duke.edu
To: linux-kernel@vger.kernel.org
Subject: mtrr registers with >= 4GB ram
Message-ID: <alpine.LNX.1.10.0807021049580.15549@localhost>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-PMX-Version: 5.4.2.338381, Antispam-Engine: 2.6.0.325393, Antispam-Data: 2008.7.2.144155
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As documented at https://bugs.launchpad.net/linux/+bug/210780 and 
http://www.rage3d.com/board/showthread.php?t=33821469 (as well as other 
places - google 4gb mtrr bug), the kernel appears to misdetect the mtrr 
registers on many machines with 4gb ram, causing all sorts of issues - 
especially with video drivers in X.  It is possible to rewrite the correct 
registers using a pretty hackish script, but the bug should probably be 
fixed at the kernel level.

Please CC me personally when replying, as I'm not on LKML.  I'd be happy 
to try out patches if such come along :)

Thanks,
Rann
