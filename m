Return-Path: <linux-kernel-owner+w=401wt.eu-S932495AbYFGWHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495AbYFGWHh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 18:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760651AbYFGV6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 17:58:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:43422 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765211AbYFGV6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 17:58:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VhR1fke5zIsTdlZs+OHWMl0GAU7OVXmCf1PljIX+jXjjlWM1keEGYYwcWe9P0BBuxL
         ygL45QPMvi2M/2ttzYrFKw/sblGzyDSmROsXlqqmNq2eCPztiQhHV6dtQp2Fq6/T0u+E
         5pqHamKir7wCSI5zgpDBBLRJWEpepk4Yrc5BE=
Message-ID: <19f34abd0806071458l407a86abt40edf943f54f5e03@mail.gmail.com>
Date: Sat, 7 Jun 2008 23:58:43 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, "Lin Ming" <ming.m.lin@intel.com>
Subject: Re: [Bug #10669] ACPI: kmemcheck: Caught 16-bit read from freed memory (f7c12ec6)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <dCRO4tbfLzK.A.jDF.D5vSIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
	 <dCRO4tbfLzK.A.jDF.D5vSIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 7, 2008 at 10:42 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10669
> Subject         : ACPI: kmemcheck: Caught 16-bit read from freed memory (f7c12ec6)
> Submitter       : Vegard Nossum <vegard.nossum@gmail.com>
> Date            : 2008-05-06 16:09 (33 days old)
> References      : http://marc.info/?l=linux-acpi&amp;m=121009034825514&amp;w=4
> Handled-By      : Lin Ming <ming.m.lin@intel.com>
>                  Ming Lin <ming.m.lin@intel.com>
> Patch           : http://bugzilla.kernel.org/attachment.cgi?id=16199&amp;action=view
>

I'm sorry, I have no idea why this fix isn't going upstream. I tested
the patch and it's completely fine with regards to kmemcheck. And the
patch it fixes was already upstream so I don't see what's stopping it
from going back in + the fix.

So the question is if this should go in now, or whether it should wait
till 2.6.26. In either case, the regression itself was solved by the
means of a revert, and that's quite a long time ago, so the current
kernel should be fine in this regard, though I think the original
patch fixed some errors on its own.

Ming Lin, will you resubmit the original patch plus the fix for
re-inclusion in mainline? There's no point in having this regression
entry around when it has been fixed by either/both the revert or/and
the extra "fix" patch.

Thanks! :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
