Return-Path: <linux-kernel-owner+w=401wt.eu-S1763324AbZAOSu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763324AbZAOSu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 13:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbZAOSuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 13:50:16 -0500
Received: from adelie.canonical.com ([91.189.90.139]:34266 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbZAOSuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 13:50:14 -0500
Date: Thu, 15 Jan 2009 18:50:09 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: davej@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: scripts/checkpatch.pl: WARNING: patch prefix 'arch' exists,
	appears to be a -p0 patch
Message-ID: <20090115185009.GE6896@shadowen.org>
References: <3f9a31f40901120903yc6a85e0w4c2fe57352f1f482@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40901120903yc6a85e0w4c2fe57352f1f482@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 10:33:40PM +0530, Jaswinder Singh Rajput wrote:
> Hello Andy,
> 
> How to get rid of this warning:
> 
>  #./scripts/checkpatch.pl --file arch/x86/kernel/module_32.c
> WARNING: patch prefix 'arch' exists, appears to be a -p0 patch
> 
> total: 0 errors, 1 warnings, 152 lines checked
> 
> arch/x86/kernel/module_32.c has style problems, please review.  If any
> of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.

That looks wrong to me.  Will have a look at it.

Ahh yes, thats just wrong.  Should be fixed in the tip of my tree, and
will be in the next block of updates.  You can check against the version
at:

  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

-apw
