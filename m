Return-Path: <linux-kernel-owner+w=401wt.eu-S1758684AbXFIRmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684AbXFIRmQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 13:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758039AbXFIRlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 13:41:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:5587 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736AbXFIRlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 13:41:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=R/GzNGg89a2ebXkO75GW1SPddF1Rz0qIiniAeNSENwlJp5rZWxL111vQJRCCJ/uIU/Syq3XndQ5oIdRH53W6nWNiHW03psS7PwntT6Bzu0L4PCTz8ynk3AWEn7Z+8tMNVST4/Hg5R5/EessMNsruKbvyZevHA0CAmQWA5uR7OVI=
Message-ID: <466AE619.2000706@googlemail.com>
Date: Sat, 09 Jun 2007 19:40:41 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Alan Cox <alan@redhat.com>, Jean-Luc Coulon <jean.luc.coulon@gmail.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, Ingo Molnar <mingo@elte.hu>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Simon <sg02r@ecs.soton.ac.uk>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>, Paulo Pereira <pfmp.404@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [2/2] 2.6.22-rc4: known regressions with patches v2
References: <466AE54A.3040902@googlemail.com>
In-Reply-To: <466AE54A.3040902@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc4
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



SATA/PATA

Subject    : disk on promise pdc20378 disabled at boot
References : http://bugzilla.kernel.org/show_bug.cgi?id=8587
Submitter  : Jean-Luc Coulon <jean.luc.coulon@gmail.com>
Handled-By : Tejun Heo <htejun@gmail.com>
Caused-By  : Tejun Heo <htejun@gmail.com>
             commit 464cf177df7727efcc5506322fc5d0c8b896f545
Patch      : http://lkml.org/lkml/2007/6/6/112
Status     : patch available



SELinux

Subject    : very high non-preempt latency in context_struct_compute_av()
References : http://lkml.org/lkml/2007/6/4/78
Submitter  : Ingo Molnar <mingo@elte.hu>
Handled-By : Stephen Smalley <sds@tycho.nsa.gov>
             James Morris <jmorris@namei.org>
Patch      : http://lkml.org/lkml/2007/6/7/334
Status     : patch available



Suspend

Subject    : panic on s3 resume with uhci_hcd module
References : http://bugzilla.kernel.org/show_bug.cgi?id=8565
Submitter  : Simon <sg02r@ecs.soton.ac.uk>
Handled-By : Rafael J. Wysocki <rjw@sisk.pl>
Patch      : http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc3/patches/21-firewire-implement-suspend-resume-hooks.patch
Status     : patch available



USB

Subject    : list_add corruption. prev->next should be next (f7d28794), but was f0df8ed4 (prev=f0df8ed4) Kernel Bug at lib/list_debug.c:33
References : http://bugzilla.kernel.org/show_bug.cgi?id=8561
Submitter  : Paulo Pereira <pfmp.404@gmail.com>
Handled-By : Alan Stern <stern@rowland.harvard.edu>
Patch      : http://bugzilla.kernel.org/show_bug.cgi?id=8561#c8
Status     : patch was suggested



Regards,
Michal

--
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"
