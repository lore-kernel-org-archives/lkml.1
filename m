Return-Path: <linux-kernel-owner+w=401wt.eu-S1758884AbYCYW3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884AbYCYW3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 18:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbYCYW3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 18:29:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59671 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752533AbYCYW3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 18:29:09 -0400
Date: Tue, 25 Mar 2008 15:28:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug 10328] New: [regression] performance drop for glx
Message-Id: <20080325152809.e2b07251.akpm@linux-foundation.org>
In-Reply-To: <bug-10328-27@http.bugzilla.kernel.org/>
References: <bug-10328-27@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Tue, 25 Mar 2008 15:11:15 -0700 (PDT)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=10328
> 
>            Summary: [regression] performance drop for glx
>            Product: Memory Management
>            Version: 2.5
>      KernelVersion: 2.6.25-rc6
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: akpm@osdl.org
>         ReportedBy: bug-track@fisher-privat.net
> 
> 
> after commit 4138cc3418f5eaa7524ff8e927102863f1ba0ea5 i expirience some grafik
> related perfomance issues.
> 
> I used glxgears for test.
> before this patch: 1281.005 FPS
> and after: 765.000 FPS

It nearly halved.

> latest tested commit a4083c9271e0a697278e089f2c0b9a95363ada0a
> still hase bad performance.
> 
> I use Pentium D with 2GB RAM, Grafick: i945G, ICH7
> 

That's 

: commit 4138cc3418f5eaa7524ff8e927102863f1ba0ea5
: Author: Siddha, Suresh B <suresh.b.siddha@intel.com>
: Date:   Wed Jan 30 13:33:43 2008 +0100
: 
:     x86: set strong uncacheable where UC is really desired
:     
:     Also use _PAGE_PWT for all the mappings which need uncache mapping.
:     Instead of existing PAT2 which is UC- (and can be overwritten by MTRRs),
:     we now use PAT3 which is strong uncacheable.
:     
:     This makes it consistent with pgprot_noncached()
:     
:     Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
:     Signed-off-by: Ingo Molnar <mingo@elte.hu>
:     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
: 


