Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbZCGWX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbZCGWX3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 17:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbZCGWXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 17:23:21 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:32548 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbZCGWXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 17:23:21 -0500
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: linux-kernel@vger.kernel.org
Subject: Problem on F10 with 2.6.29-rc7
Date: Sat, 07 Mar 2009 17:23:10 -0500
User-Agent: KMail/1.11.0 (Linux/2.6.28.7; KDE/4.2.0; i686; ; )
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200903071723.11112.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

I've been meaning to post this for several days.  I built 2.6.29-rc7 the night 
it was released and was booted to it for about 4 hours the next morning, but 
lots of things didn't work or feel right.  On investigation the usual 
complement of about 50 copies of console-helper-daemon were not running.  
Rebooting to my current 2.6.28.7 restored the console-help-daemon to the alive 
and well status.  

su'ing to a user was one of the things that just didn't work, no user $PATH 
seemed to be part of the problem, but an echo $PATH indicted it was normal.

The system gradually fell apart, and I tried to do a graceful shutdown/reboot 
to see if it would preserve a working network, but that failed and I had to 
use the reset button after a couple of minutes.  I don't recall now where it 
hung on the shutdown now, but I do recall seeing several bright-red FAIL 
messages go by before it hung. It had not managed to turn off the network 
PHY's by the time it had hung, so I didn't get a chance to see if 2.6.28.7 
would restore them, or if I had to go through the complete powerdown of the 
whole room for 30 seconds to reset those as I had to do several times when 
running 2.6.29-rc5.  That, IMO, is a PITA.  And no one has explained the 
reason for this change that doesn't seem to appear in the ChangeLogs in 
recognizable form.

I have also had to wander through the system resetting both ownerships and 
selinux contexts for about 50 files since that 4 hour session.

Can someone clarify this for me?


-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
"Success covers a multitude of blunders."
-- George Bernard Shaw

