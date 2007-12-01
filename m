Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbXLAUYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbXLAUYJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 15:24:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbXLAUX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 15:23:58 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52418 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751376AbXLAUX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 15:23:57 -0500
Date: Sat, 1 Dec 2007 12:23:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: jnelson-kernel-bugzilla@jamponi.net
Cc: bugme-daemon@bugzilla.kernel.org, "Ed L. Cashin" <ecashin@coraid.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bugme-new] [Bug 9482] New: kernel GPF in 2.6.24 (g09f345da)
Message-Id: <20071201122302.10dd9c44.akpm@linux-foundation.org>
In-Reply-To: <bug-9482-10286@http.bugzilla.kernel.org/>
References: <bug-9482-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(switched to email - please respond via emailed reply-to-all, not via the
bugzilla web interface)

On Sat,  1 Dec 2007 11:54:11 -0800 (PST) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=9482
> 
>            Summary: kernel GPF in 2.6.24 (g09f345da)
>            Product: Other
>            Version: 2.5
>      KernelVersion: 2.6.24rc3 g09f345da
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: other_other@kernel-bugs.osdl.org
>         ReportedBy: jnelson-kernel-bugzilla@jamponi.net
> 
> 
> Most recent kernel where this bug did not occur: 2.6.22.12
> Distribution: openSUSE 10.3
> Hardware Environment: Athlon XP 2200+
> Software Environment: openSUSE 10.3
> Problem Description: instant kernel GPF.
> 
> Steps to reproduce:load module aoe (vanilla), type 'mkfs.ext3
> /dev/etherd/e0.0', and the kernel GPFs.
> 
> Will be attaching jpg of screen - sorry, no other way to capture GPF for me.
> 

http://bugzilla.kernel.org/attachment.cgi?id=13812&action=view

Damn that's odd.  General Protection Fault in
__set_page_dirty->__percpu_counter_add().  No sign of AOE in the trace.

I assume that it is repeatable and that it doesn't occur with mkfs on
regular local disk drives?
