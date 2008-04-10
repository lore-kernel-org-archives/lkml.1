Return-Path: <linux-kernel-owner+w=401wt.eu-S1759324AbYDJPaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324AbYDJPaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbYDJPaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:30:12 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56298 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756050AbYDJPaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:30:11 -0400
Date: Thu, 10 Apr 2008 10:30:08 -0500
From: Paul Jackson <pj@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: travis@sgi.com, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86: add cpus_scnprintf function v2
Message-Id: <20080410103008.e4c053b9.pj@sgi.com>
In-Reply-To: <20080407081643.GC3066@elte.hu>
References: <20080405012447.440875000@polaris-admin.engr.sgi.com>
	<20080407030421.0c3f8033.pj@sgi.com>
	<20080407081643.GC3066@elte.hu>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, responding to Paul, three days ago:
> i dont mind the old patch either (which did an ugly temporary 
> allocation), if it keeps the ABI.

But this v2 and earlier patch versions broke the kernel-user interface,
incompatibly, for about a dozen different /sys and /proc files, and
without even stating so very clearly in the patch commentary.  We'd
have to be rather desperate before I'd agree to that.

Mike's latest v3 version of this cpus_scnprintf patchset has resolved
these incompatibilities, by adding new *list files in /sys and /proc,
and new *list line items in the /proc/<pid>/status files, rather than
breaking existing files and lines.

That is much better.  Better to add files and lines, than to change the
format of existing ones.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
