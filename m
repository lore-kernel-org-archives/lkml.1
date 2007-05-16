Return-Path: <linux-kernel-owner+w=401wt.eu-S1763495AbXEPUcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763495AbXEPUcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 16:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933264AbXEPUcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 16:32:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:18010 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762786AbXEPUb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 16:31:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=Q5bkri1CQuQZnVnfJj5pXTkR+UWnogYdbt6mjEvVoJd2NH4K6gQrJB2rJWItlNPTIJDtxqjCy5yRriw0GTEzIIy6AxM97YwPHCENuvN0tIbBzVV/H0xssvWk9aeiJG6AX+JSLl7pjtOIKqLl6LJUERIJ5hcQpFoUCziq1tce3t8=
Message-ID: <464B6A2F.9040605@googlemail.com>
Date: Wed, 16 May 2007 22:31:43 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-usb-devel@lists.sourceforge.net,
       "art@usfltd.com" <art@usfltd.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       video4linux@list.redhat.com,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Hans Verkuil <hverkuil@xs4all.nl>, Robert Fitzsimons <robfitz@273k.net>,
       netdev@vger.kernel.org, Auke Kok <auke-jan.h.kok@intel.com>,
       Doug Chapman <doug.chapman@hp.com>, Jeb Cramer <cramerj@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       e1000-devel@lists.sourceforge.net
Subject: Re: [3/3] 2.6.22-rc1: known regressions v2
References: <464B6743.9000607@googlemail.com> <464B6895.60806@googlemail.com>
In-Reply-To: <464B6895.60806@googlemail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc1.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Timers/NOHZ

Subject    : 2.6.21-git4 BUG: soft lockup detected on CPU#1! 
References : http://lkml.org/lkml/2007/5/2/511
Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
Status     : problem is being debugged



USB

Subject    : usb hotplug/udev cannot correctly register usb/scanners
References : http://lkml.org/lkml/2007/5/15/205
Submitter  : art@usfltd.com <art@usfltd.com>
Status     : Unknown



V4L

Subject    : V4L ABI breakage
References : http://lkml.org/lkml/2007/5/14/42
Submitter  : Robert Fitzsimons <robfitz@273k.net>
Caused-By  : Hans Verkuil <hverkuil@xs4all.nl>
             Mauro Carvalho Chehab <mchehab@infradead.org>
             commit 206ebaf32795cf1582b1e2ff2ec6a560c9e986b8
Status     : Unknown



Networking

Subject    : panic with e1000 driver on HP Integrity servers
References : http://bugzilla.kernel.org/show_bug.cgi?id=8455
Submitter  : Doug Chapman <doug.chapman@hp.com>
Caused-By  : Auke Kok <auke-jan.h.kok@intel.com>
             commit e0aac5a289b1dacbc94bd9ae8c449bcdf9ab508c
Status     : problem is being debugged



Regards,
Michal

--
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
