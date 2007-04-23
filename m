Return-Path: <linux-kernel-owner+w=401wt.eu-S1161206AbXDWGZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161206AbXDWGZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 02:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161242AbXDWGZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 02:25:49 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51683 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161206AbXDWGZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 02:25:48 -0400
Date: Mon, 23 Apr 2007 11:55:34 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Jurriaan <thunder7@xs4all.nl>, Helge Hafting <helgehaf@aitel.hist.no>,
       linux-kernel@vger.kernel.org, Magnus Damm <magnus@valinux.co.jp>,
       Horms <horms@verge.net.au>, fastboot@osdl.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH 2/2] x86_64: Remove CONFIG_PHYSICAL_START and CONFIG_RELOCATABLE
Message-ID: <20070423062534.GB14664@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <m1abxrf9o3.fsf@ebiederm.dsl.xmission.com> <20070402094520.GC13704@in.ibm.com> <m1648eg01d.fsf@ebiederm.dsl.xmission.com> <20070403040152.GA5108@in.ibm.com> <m1zm5qc9q2.fsf@ebiederm.dsl.xmission.com> <20070403100349.GA21759@in.ibm.com> <m18xcjznbm.fsf_-_@ebiederm.dsl.xmission.com> <m14pn7zn5n.fsf_-_@ebiederm.dsl.xmission.com> <20070423060739.GA14664@in.ibm.com> <m1slary5ql.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1slary5ql.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 12:17:22AM -0600, Eric W. Biederman wrote:
> Vivek Goyal <vgoyal@in.ibm.com> writes:
> 
> > On Sun, Apr 22, 2007 at 11:15:48PM -0600, Eric W. Biederman wrote:
> >> +++ b/arch/x86_64/Kconfig
> >> @@ -565,62 +565,9 @@ config CRASH_DUMP
> >>            which are loaded in the main kernel with kexec-tools into
> >>            a specially reserved region and then later executed after
> >>            a crash by kdump/kexec. The crash dump kernel must be compiled
> >> -	  to a memory address not used by the main kernel or BIOS using
> >> -	  PHYSICAL_START.
> >> +	  to a memory address not used by the main kernel or BIOS
> >>            For more details see Documentation/kdump/kdump.txt
> >
> > Hi Eric,
> >
> > I think "must be compiled" should be replaced with "must be loaded" now.
> 
> Yes, that sounds right.  Ugh.  I didn't look at enough context to read
> the whole sentence.  I just killed the part about PHYSICAL_START.
> 
> > Otherwise both the patches look fine.  I am planning to test these.
> >
> > This change will also require modifications to Documentation/kdump/kdump.txt
> > file.
> 
> Do you think you can generate the patch fix up the CONFIG_CRASH_DUMP
> and kdump.txt documentation.
> 

Ok. I will send one.

Thanks
Vivek
