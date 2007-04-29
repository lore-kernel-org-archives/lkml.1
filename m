Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbXD2Evd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbXD2Evd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 00:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbXD2Evd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 00:51:33 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46151 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbXD2Evb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 00:51:31 -0400
Date: Sun, 29 Apr 2007 10:20:24 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <ak@suse.de>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
Message-ID: <20070429045024.GA27000@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070428758.455116000@suse.de> <20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org> <m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4633B0BB.6080600@zytor.com> <m1bqh8dy79.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bqh8dy79.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 02:46:18PM -0600, Eric W. Biederman wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
> > Eric W. Biederman wrote:
> >> 
> >> The boot protocol change is in 2.6.21 for arch/i386.
> >> 
> >> HPA looked at it a while ago.
> >> 
> >> All it does is set a flag that tells a bootloader.
> >> "Hey. I can run when loaded a non-default address, and this is what
> >>  you have to align me to."
> >> 
> >> All relocation processing happens in the kernel itself.
> >> 
> >> So it is all pretty trivial.
> >> 
> >
> > Indeed.  We *did* find some problems with Grub with the early versions,
> > those were addressed.
> 
> We found some failures that weren't root caused so we went to this
> more conservative version.
> 
> RHEL5 is actually shipping the original version of these patches if I
> recall correctly.
> 

Yes, RHEL5 is shipping original version of patches where an where and ELF
header has been added to describe bzImage.

Thanks
Vivek
