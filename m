Return-Path: <linux-kernel-owner+w=401wt.eu-S1756936AbXFZJDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936AbXFZJDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 05:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbXFZJDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 05:03:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39556 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751147AbXFZJDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 05:03:06 -0400
Date: Tue, 26 Jun 2007 02:02:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Cc: "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@kernel-bugs.osdl.org>,
       linux@solnet.ch
Subject: Re: [Bugme-new] [Bug 8677] New: booting with initrd fails:
 request_module: runaway loop modprobe binfmt-0000
Message-Id: <20070626020256.4a03d6b2.akpm@linux-foundation.org>
In-Reply-To: <bug-8677-10286@http.bugzilla.kernel.org/>
References: <bug-8677-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 01:48:51 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=8677
> 
>            Summary: booting with initrd fails: request_module: runaway loop
>                     modprobe binfmt-0000
>            Product: Other
>            Version: 2.5
>      KernelVersion: 2.6.22_rc*
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: other_other@kernel-bugs.osdl.org
>         ReportedBy: linux@solnet.ch
> 
> 
> Most recent kernel where this bug did not occur:2.6.21
> Distribution: gentoo
> Hardware Environment: IBM Thinkpad T43
> Software Environment:
> Problem Description:
> 
> I can't boot all 2.6.22_rc* kernels with an initrd. When booting I get the
> following message about 6 times:
> 
> request_module: runaway loop modprobe binfmt-0000
> 
> If I disable the initrd, booting works without problems.
> 
> 

I seem to recall having seen reports of this before.  Does anyone recall
the reason for it?
