Return-Path: <linux-kernel-owner+w=401wt.eu-S1760729AbXGJMsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760729AbXGJMsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 08:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbXGJMp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 08:45:57 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:36624 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758594AbXGJMpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 08:45:55 -0400
Date: Tue, 10 Jul 2007 08:45:39 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: 2.6.22 vs amanda, 2.6.22 1, amanda 0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200707100845.40304.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

Running 2.6.22 with no other patches last night, something went south in my 
amanda backup run, and so far my forensics are coming up empty.  The only 
obvious thing is that an amdump.1 file was not generated, and when I awoke 
this am, cupsd was stuck and using 70+% of the cpu, and there were several 
amanda related procs apparently waiting on it.  I restarted cups which will 
normally unjam the jobs and complete any pending, but none were pending even 
before I restarted cups.  After the cups restart, the amanda related stuff 
went away and the cpu cooled down by 15 degrees.

The expected files were written to the tape however.

I will now reboot to 2.6.22-ck1 as the scheduler performance with a plain .22 
is back to normal, with kmail being hung for 30 seconds at a time.  This is 
not acceptable performance for a desktop even with full pre-emption checked 
in the build config.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Giving money and power to governments is like giving whiskey and
car keys to teenage boys.
	-- P.J. O'Rourke
