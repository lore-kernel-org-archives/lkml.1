Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbYJ2Ui2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbYJ2Ui2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 16:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbYJ2UiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 16:38:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42753 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbYJ2UiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 16:38:18 -0400
Date: Wed, 29 Oct 2008 16:39:19 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] NMI watchdog: add support to enable and disable
	IOAPIC NMI
Message-ID: <20081029203918.GN771@redhat.com>
References: <20081027164233.132189000@napanee.usersys.redhat.com> <20081027164234.679734000@napanee.usersys.redhat.com> <20081029090532.cc9536d9.randy.dunlap@oracle.com> <alpine.LFD.1.10.0810291941510.13373@ftp.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0810291941510.13373@ftp.linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > This patch adds support to enable/disable IOAPIC NMI watchdog in runtime via
> > > procfs.
> > 
> > Some info on how to use this, what to write(?) to what file(?) in procfs
> > would be Very Good to have.
> 
>  I gather this is an extension to the existing interface already covering 
> the local APIC NMI watchdog, which surely ;) must have been documented at 
> the time it was added.  If it wasn't, then we cannot require it now as a 
> prerequisite to accept this patch, although such documentation would be 
> desirable as a separate submission.
What about (if OK, I'll resubmit in a different thread with proper format):

---
 Documentation/nmi_watchdog.txt |    5 +++++
 1 file changed, 5 insertions(+)

--- linus-2.6.orig/Documentation/nmi_watchdog.txt	2008-10-24 11:41:30.000000000 -0400
+++ linus-2.6/Documentation/nmi_watchdog.txt	2008-10-29 16:38:12.000000000 -0400
@@ -69,6 +69,11 @@ to the overall system performance.
 On x86 nmi_watchdog is disabled by default so you have to enable it with
 a boot time parameter.
 
+It's possible to disable the NMI watchdog in run-time by writing "0" to
+/proc/sys/kernel/nmi_watchdog. Writing "1" to the same file will re-enable
+the NMI watchdog. Notice that you still need to use "nmi_watchdog=" parameter
+in boot time.
+
 NOTE: In kernels prior to 2.4.2-ac18 the NMI-oopser is enabled unconditionally
 on x86 SMP boxes.
 
