Return-Path: <linux-kernel-owner+w=401wt.eu-S1761617AbYEAPft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761617AbYEAPft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 11:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbYEAPfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 11:35:43 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:19154 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809AbYEAPfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 11:35:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=e/4TOobZkSTV6Ua5gZTlJYggTDv9xjafnmhnbo8oghBhKjQbKaTu3oHTpD42hcIuE2B7/NwVdIYaP0K+aRk698/QMJnCHPt7cZLm4mfYGzkqcgF0kwc65NqESiqEoGmCk1+lSFqOHbUA7O81FRRpQGPV+Oa7Lfcjo4Lz28wuf50=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: dvd writing problem
Date: Thu, 1 May 2008 11:35:38 -0400
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805011135.38556.gene.heskett@gmail.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all;

I'm going to describe the problem, and let you tell me where to report it.

System is Biostart MB, XP-2800 cpu, gig of ram.

1. burn dvd image using k3b, with write verify turned on.

2. when disk is ejected at end of a successful burn, then pulled back in, a 
read error is reported long before the drive has recognized the disk, the 
disk is ejected again and k3b bails out of the verify phase.  This does not 
occur for a cd-r.

3. manually close drive with the disc still in the tray.

4. About 40 secs later, at about the time the drive would have accepted the 
disc as a valid disc, the system is frozen solidly, no drive leds on and the 
clock in the corner of the screen is stopped.  I have let it sit that way for 
as long as 2 minutes before tapping the hardware reset button.

5. Eject the disc while its posting and reboot, to either 2.6.24.5 or 2.6.25, 
both do exactly the same actions.

6. Once system is up again, re-insert disc, wait for drive to accept it, then 
do a verify by hand, disc is good, it can be mounted and read just fine.

7. disc is a +RW disc, so it should be re-writable.  Pick a different .iso and 
start k3b again using it.  K3b goes through the motions, but 2 or 3 seconds 
after the real write starts with perhaps 30 megabytes *supposedly* written, 
k3b gets a write error and the burn bails out, ejecting the disc as it does. 

8. insert disc and loop this sequence back to #3 above until tired of 
rebooting cuz the box is frozen.  Once rebooted, and the disc inspected, it 
is obvious the second write never touched the disc as the first write is 
still there and passes the sh1sum or md5sum test correctly.

Sebastian Truex and I have been discussing this for a while now, and I have 
even replaced the writer drive, a LITEON that I started with, with an HP, 
even faster drive, without changing a thing above.  It is 100% repeatable.

Where do I file the bug report?  There are no interesting entries in the 
messages log, no oops, nothing.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Happiness, n.:
	An agreeable sensation arising from contemplating the misery of another.
		-- Ambrose Bierce, "The Devil's Dictionary"
