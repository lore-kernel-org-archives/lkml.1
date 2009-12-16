Return-Path: <linux-kernel-owner+w=401wt.eu-S935451AbZLPWdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935451AbZLPWdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:33:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935393AbZLPWde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:33:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59427 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935250AbZLPWdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:33:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Wed, 16 Dec 2009 23:33:57 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912162257.00771.rjw@sisk.pl> <alpine.LFD.2.00.0912161410120.3556@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912161410120.3556@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912162333.57245.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 December 2009, Linus Torvalds wrote:
> 
> Btw, what are the timings if you just force everything async? I think that 
> worked on yur laptops, no?

No, it didn't.  I could make all PCI async, provided that the ACPI subtree was
resumed before any PCI devices.  [Theoretically I can make that happen by
moving ACPI resume to the _noirq phase (just for testing of course).  So I can
try to make PCI async in addition to serio and USB, plus i8042 perhaps, which
should be sfficient for the nx6325 I think.]

Making all async always hanged the boxes on resume.

Rafael
