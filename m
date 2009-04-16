Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbZDPVKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbZDPVKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 17:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZDPVKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 17:10:14 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:60501 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbZDPVKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 17:10:12 -0400
Message-ID: <49E79E58.9000606@nortel.com>
Date: Thu, 16 Apr 2009 15:08:40 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Trenton Adams <trenton.d.adams@gmail.com>
Subject: Re: 2.6.29-git13: Reported regressions from 2.6.28
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera> <alpine.LFD.2.00.0904061443000.7443@localhost.localdomain> <200904070035.00784.rjw@sisk.pl>
In-Reply-To: <200904070035.00784.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Apr 2009 21:08:43.0944 (UTC) FILETIME=[866F0A80:01C9BED7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Monday 06 April 2009, Linus Torvalds wrote:
>> On Mon, 6 Apr 2009, Rafael J. Wysocki wrote:
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13019
>>> Subject		: /proc/<pid>/maps offset output broken in 2.6.29
>>> Submitter	: "Chris Friesen" <cfriesen@nortel.com>
>>> Date		: 2009-04-01 23:18 (6 days old)
>>> References	: http://marc.info/?l=linuxppc-embedded&m=123862902916059&w=4
>>> Handled-By	: Hugh Dickins <hugh@veritas.com>
>> I don't think that's a regression, nor really a bug. It looks cosmetic, 
>> and likely to be fixed, but not really worth worrying about.
> 
> OK, I've dropped it from the list.

I'm okay with that.  The problem causes some backwards compatibility 
problems with existing apps that get confused by the large "offset" 
number.  The fix is going to cause problems too, but in a different way.

We'll work around it.

Chris
