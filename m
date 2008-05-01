Return-Path: <linux-kernel-owner+w=401wt.eu-S1764718AbYEAUYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764718AbYEAUYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 16:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYEAUYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 16:24:12 -0400
Received: from smtpreverse2.ch2m.com ([198.91.8.58]:43095 "EHLO mail.ch2m.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751556AbYEAUYM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 16:24:12 -0400
X-Greylist: delayed 909 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 May 2008 16:24:12 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Bugme-new] [Bug 10586] New: High Number of Segfaults onMacBook Starting With 2.6.24.5 Kernel
Date: Thu, 1 May 2008 14:09:00 -0600
Message-ID: <86A21F45FFA48B408A65E67054362EB6069DD742@CULEBRA.amr.ch2m.com>
In-Reply-To: <20080501130444.cc5c63e8.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Bugme-new] [Bug 10586] New: High Number of Segfaults onMacBook Starting With 2.6.24.5 Kernel
Thread-Index: Acirxpx29aD6c87yRpaOVcXQ7sUWwwAAEKFg
References: <bug-10586-10286@http.bugzilla.kernel.org/> <20080501130444.cc5c63e8.akpm@linux-foundation.org>
From: <Ryan.Roth@CH2M.com>
To: <akpm@linux-foundation.org>
Cc: <bugme-daemon@bugzilla.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 01 May 2008 20:09:01.0457 (UTC) FILETIME=[32866810:01C8ABC7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes there is a issue with a lot of apps dying, especially the
gnome-power-* apps which means my power management fails to work
frequently.  I'm on Git-10 currently and I'm going to patch it up to
date right now because it looks like there have been some memory remap
patches lately.  I will update the list after I do so.

-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org] 
Sent: Thursday, May 01, 2008 1:05 PM
To: Roth, Ryan/RDD
Cc: bugme-daemon@bugzilla.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10586] New: High Number of Segfaults
onMacBook Starting With 2.6.24.5 Kernel

(switched to email.  Please respond via emailed reply-to-all, not via
the bugzilla web interface).

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
> Problem Description:  Extremely high number of segfaults.  Suspect 
> that this may have to do with some sort of change in memory remapping 
> changes in the kernel.

This report is a bit mysterious.  I assume you're referring to x86's

	"%s%s[%d]: segfault at %lx ip %08lx sp %08lx error %lx"

printk in the kernel logs?

Can you please send some examples of the log output?

Is there actually any observeable problem apart from the logs?  Are
applications dying where they previously did not?

Thanks.

