Return-Path: <linux-kernel-owner+w=401wt.eu-S1765618AbYEAUFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765618AbYEAUFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 16:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763008AbYEAUEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 16:04:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760037AbYEAUEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 16:04:48 -0400
Date: Thu, 1 May 2008 13:04:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ryan.roth@ch2m.com
Cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10586] New: High Number of Segfaults on
 MacBook Starting With 2.6.24.5 Kernel
Message-Id: <20080501130444.cc5c63e8.akpm@linux-foundation.org>
In-Reply-To: <bug-10586-10286@http.bugzilla.kernel.org/>
References: <bug-10586-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Thu,  1 May 2008 12:30:18 -0700 (PDT)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=10586
> 
>            Summary: High Number of Segfaults on MacBook Starting With
>                     2.6.24.5 Kernel
>            Product: Memory Management
>            Version: 2.5
>      KernelVersion: 2.6.24.5
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: akpm@osdl.org
>         ReportedBy: ryan.roth@ch2m.com
> 
> 
> Latest working kernel version:  2.6.23?
> Earliest failing kernel version:  2.6.24.5
> Distribution: Fedora 8 x86_64
> Hardware Environment:  MacBook
> Problem Description:  Extremely high number of segfaults.  Suspect that this
> may have to do with some sort of change in memory remapping changes in the
> kernel.

This report is a bit mysterious.  I assume you're referring to x86's

	"%s%s[%d]: segfault at %lx ip %08lx sp %08lx error %lx"

printk in the kernel logs?

Can you please send some examples of the log output?

Is there actually any observeable problem apart from the logs?  Are
applications dying where they previously did not?

Thanks.

