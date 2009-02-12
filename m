Return-Path: <linux-kernel-owner+w=401wt.eu-S1761112AbZBLWPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761112AbZBLWPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 17:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbZBLWPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 17:15:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753174AbZBLWPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 17:15:34 -0500
Date: Thu, 12 Feb 2009 14:15:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Cc: bugme-daemon@bugzilla.kernel.org, akolisek@linuxx.hyperlinx.cz
Subject: Re: [Bugme-new] [Bug 12690] New: DPMS (LCD powersave, poweroff)
 don't work
Message-Id: <20090212141521.1ed7acba.akpm@linux-foundation.org>
In-Reply-To: <bug-12690-10286@http.bugzilla.kernel.org/>
References: <bug-12690-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

Help.

On Wed, 11 Feb 2009 09:40:40 -0800 (PST)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=12690
> 
>            Summary: DPMS (LCD powersave, poweroff) don't work
>            Product: Power Management
>            Version: 2.5
>      KernelVersion: 2.6.28.4
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: power-management_other@kernel-bugs.osdl.org
>         ReportedBy: akolisek@linuxx.hyperlinx.cz
> 
> 
> Latest working kernel version: 2.6.27.X
> Earliest failing kernel version: 2.6.28.X
> Distribution:Slackware 12.2 (current)
> Hardware Environment: Lenovo 3000 C100 (i915GM)
> Software Environment:  
> Problem Description: If I boot on my PC linux-2.6.28.X LCD powerdown isn't
> functional.
> 
> Steps to reproduce:
> If I set "setterm -blank 5 -powerdown on, setterm -powerdown 15" it goes only
> LCD blanking but powerdown isn't functional. In the X (x11-xorg + KDE4.2) I set
> xset +dpms
> xset dpms force off
> DPMS don't work too.
> 

We seem to have a DPMS-related regression here and I don't even know 
which subsystem might have caused the breakage.  (iow: who do I blame? ;))

Thanks.
