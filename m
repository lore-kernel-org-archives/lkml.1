Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbYJ3AvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbYJ3AvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 20:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbYJ3Au5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 20:50:57 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:39489 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbYJ3Au4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 20:50:56 -0400
Date: Wed, 29 Oct 2008 17:50:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] NMI watchdog: add support to enable and disable
 IOAPIC NMI
Message-Id: <20081029175001.d2f9db9e.randy.dunlap@oracle.com>
In-Reply-To: <20081029203918.GN771@redhat.com>
References: <20081027164233.132189000@napanee.usersys.redhat.com>
	<20081027164234.679734000@napanee.usersys.redhat.com>
	<20081029090532.cc9536d9.randy.dunlap@oracle.com>
	<alpine.LFD.1.10.0810291941510.13373@ftp.linux-mips.org>
	<20081029203918.GN771@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008 16:39:19 -0400 Aristeu Rozanski wrote:

> > > > This patch adds support to enable/disable IOAPIC NMI watchdog in runtime via
> > > > procfs.
> > > 
> > > Some info on how to use this, what to write(?) to what file(?) in procfs
> > > would be Very Good to have.
> > 
> >  I gather this is an extension to the existing interface already covering 
> > the local APIC NMI watchdog, which surely ;) must have been documented at 
> > the time it was added.  If it wasn't, then we cannot require it now as a 
> > prerequisite to accept this patch, although such documentation would be 
> > desirable as a separate submission.
> What about (if OK, I'll resubmit in a different thread with proper format):
> 
> ---
>  Documentation/nmi_watchdog.txt |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> --- linus-2.6.orig/Documentation/nmi_watchdog.txt	2008-10-24 11:41:30.000000000 -0400
> +++ linus-2.6/Documentation/nmi_watchdog.txt	2008-10-29 16:38:12.000000000 -0400
> @@ -69,6 +69,11 @@ to the overall system performance.
>  On x86 nmi_watchdog is disabled by default so you have to enable it with
>  a boot time parameter.
>  
> +It's possible to disable the NMI watchdog in run-time by writing "0" to
> +/proc/sys/kernel/nmi_watchdog. Writing "1" to the same file will re-enable
> +the NMI watchdog. Notice that you still need to use "nmi_watchdog=" parameter
> +in boot time.
> +
>  NOTE: In kernels prior to 2.4.2-ac18 the NMI-oopser is enabled unconditionally
>  on x86 SMP boxes.

OK.  Or update Documentation/filesystems/proc.txt::nmi_watchdog
(now that I have found it).

---
~Randy
