Return-Path: <linux-kernel-owner+w=401wt.eu-S1760602AbXEJMEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760602AbXEJMEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbXEJMEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:04:23 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:17870 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbXEJMEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:04:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=BMAcRLfccwD1cq1YuGtui7VUp1vyI7CMVH9vUPMTI2OH2JsUSw6tTMpi7DbbdDCdYXrDR2MLOIhac+2/AWSo2W39XeVN64hFXgAMygOXSextHr8SE54++GW64ydBHwwpP1gClRltwJAMup33IsutSv7sayCcBywLtopGjxeeIis=
Message-ID: <46430A3D.4030004@googlemail.com>
Date: Thu, 10 May 2007 14:04:13 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, David Chinner <dgc@sgi.com>,
       pavel@suse.cz, linux-pm@lists.linux-foundation.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Alexey Dobriyan <adobriyan@sw.ru>,
       netdev@vger.kernel.org, Auke Kok <auke-jan.h.kok@intel.com>,
       Doug Chapman <doug.chapman@hp.com>, Jeb Cramer <cramerj@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       e1000-devel@lists.sourceforge.net, Thomas Gleixner <tglx@linutronix.de>
Subject: 2.6.21-gitX: known regressions
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.21-gitX.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Unclassified:

Subject    : 2.6.21-git10/11: files getting truncated on xfs (after suspend/resume?)
References : http://lkml.org/lkml/2007/5/9/410
Submitter  : Jeremy Fitzhardinge <jeremy@goop.org>
Handled-By : David Chinner <dgc@sgi.com>
Status     : problem is being debugged

Subject    : Current -git kernel kills X
References : http://lkml.org/lkml/2007/5/8/667
Submitter  : Jeff Garzik <jeff@garzik.org>
Status     : Unknown



Block devices:

Subject    : BUG in loop.ko
References : http://lkml.org/lkml/2007/5/9/510
Submitter  : Jeremy Fitzhardinge <jeremy@goop.org>
Status     : Unknown



Networking:

Subject    : panic with e1000 driver on HP Integrity servers
References : http://bugzilla.kernel.org/show_bug.cgi?id=8455
Submitter  : Doug Chapman <doug.chapman@hp.com>
Caused-By  : Auke Kok <auke-jan.h.kok@intel.com>
             commit e0aac5a289b1dacbc94bd9ae8c449bcdf9ab508c
Status     : Unknown



Timers/NOHZ:

Subject    : 2.6.21-git4 BUG: soft lockup detected on CPU#1! 
References : http://lkml.org/lkml/2007/5/2/511
Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
Status     : problem is being debugged



Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
