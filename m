Return-Path: <linux-kernel-owner+w=401wt.eu-S1752714AbYHLVot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbYHLVot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 17:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbYHLVol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 17:44:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175AbYHLVok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 17:44:40 -0400
Date: Tue, 12 Aug 2008 14:44:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: zajec5@gmail.com
Cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 11313] New: Plugging HDMI causes "unable to
 handle kernel paging request"
Message-Id: <20080812144406.0c8aff48.akpm@linux-foundation.org>
In-Reply-To: <bug-11313-10286@http.bugzilla.kernel.org/>
References: <bug-11313-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Tue, 12 Aug 2008 14:30:01 -0700 (PDT)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11313
> 
>            Summary: Plugging HDMI causes "unable to handle kernel paging
>                     request"
>            Product: Platform Specific/Hardware
>            Version: 2.5
>      KernelVersion: 2.6.27-rcX
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: x86-64
>         AssignedTo: platform_x86_64@kernel-bugs.osdl.org
>         ReportedBy: zajec5@gmail.com
>
> Latest working kernel version: 2.6.26

ugh.  Random rampant memory corruption caused by unplugging an HDMI
cable?  I'm not even sure which subsystem could be involved here.

Are you able to run a git bisection search please? 
http://www.kernel.org/doc/local/git-quick.html has some help.

Thanks.
