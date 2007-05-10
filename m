Return-Path: <linux-kernel-owner+w=401wt.eu-S1762151AbXEJW5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762151AbXEJW5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 18:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936AbXEJW5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 18:57:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:36931 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359AbXEJW5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 18:57:30 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.22 - part 2
Date: Thu, 10 May 2007 18:56:10 -0400
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200705100411.32349.lenb@kernel.org> <alpine.LFD.0.98.0705101330320.3986@woody.linux-foundation.org> <alpine.LFD.0.98.0705101353370.3986@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705101353370.3986@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705101856.11048.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 May 2007 16:56, Linus Torvalds wrote:
> 
> On Thu, 10 May 2007, Linus Torvalds wrote:
> > 
> > Seems to work for me. My evo correctly started the fan, and stopped it 
> > when the temperature went down again.
> 
> Looking at things in "top", I do end up occasionally seeing spikes where 
> kacpid takes 17% of CPU time, and kacpi_notify takes a few percent too. 
> But the machine works ok, and it doesn't seem to be horrible:
> 
>    64 ?        S<     0:15 [kacpid]
>    65 ?        S<     0:08 [kacpi_notify]
> 
> so they've gotten 23 seconds of CPU time over the 37 minutes that laptop 
> has been up now. That's arguably too much, but on the other hand, I did 
> end up trying to stress it out by doing some 3D stuff while compiling the 
> kernel and doing "git grep" over the kernel tree etc.

Thanks, I noticed the same thing on an nx6325.
The goal at the moment is to revert to the simplest functional & stable solution --
as what is shipping today crashes on some boxes.

We've got a couple of tweaks in mind where we think Linux can get
smarter -- but this is an area where several platform vendors are taking
advantage of Windows' implementation in (different) twisted ways.
For us to reach our goal of Linux handling any system out there
in as optimal a way as possible, we need to study each one in detail.

That said, can you send me or point me to the acpidump output
for your EVO.  Yes, I'm sure you've sent it before a long time
ago, but that was about probably 2,000,000 e-mail messages
and a couple of disk crashes ago:-)

thanks,
-Len
