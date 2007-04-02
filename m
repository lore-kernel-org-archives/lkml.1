Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbXDBO7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbXDBO7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 10:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbXDBO7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 10:59:47 -0400
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1165 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbXDBO7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 10:59:46 -0400
Date: Mon, 2 Apr 2007 16:59:26 +0200
From: thunder7@xs4all.nl
To: thunder7@xs4all.nl
Cc: Vivek Goyal <vgoyal@in.ibm.com>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Helge Hafting <helgehaf@aitel.hist.no>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm3 - no boot, "address not 2M aligned"
Message-ID: <20070402145926.GA25824@amd64.of.nowhere>
References: <20070330010559.2a232d9a.akpm@linux-foundation.org> <20070331071220.GA26910@aitel.hist.no> <20070331005303.354411f0.akpm@linux-foundation.org> <20070401052932.GA9894@amd64.of.nowhere> <m1ircghb6w.fsf@ebiederm.dsl.xmission.com> <20070331232957.e1c93f19.akpm@linux-foundation.org> <20070402074159.GA13704@in.ibm.com> <20070402111745.GA9882@amd64.of.nowhere> <20070402113639.GD13704@in.ibm.com> <20070402144914.GA22725@amd64.of.nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402144914.GA22725@amd64.of.nowhere>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: thunder7@xs4all.nl <thunder7@xs4all.nl>
Date: Mon, Apr 02, 2007 at 04:49:14PM +0200
> 
> I used a working 2.6.21-rc3-mm2 tree, patched it up to 2.6.21-rc5-mm3
> and applied your patch. I ended up with the .config later in this email,
> and got this error:
> 
>   CC      arch/x86_64/kernel/head64.o
> arch/x86_64/kernel/head64.c: In function 'x86_64_start_kernel':
> arch/x86_64/kernel/head64.c:70: error: size of array 'type name' is negative
> make[1]: *** [arch/x86_64/kernel/head64.o] Error 1
> make: *** [arch/x86_64/kernel] Error 2
> 
> After reverting your patch, the build didn't fail, but of course the
> kernel won't build.
> 
That should, of course, read 'kernel won't boot'.

Sorry,
Jurriaan
-- 
Debian (Unstable) GNU/Linux 2.6.21-rc5-mm3 2x4826 bogomips load 0.92
the Jack Vance Integral Edition: http://www.integralarchive.org
