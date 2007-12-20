Return-Path: <linux-kernel-owner+w=401wt.eu-S1765174AbXLTOiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765174AbXLTOiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934122AbXLTOX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:23:28 -0500
Received: from main.gmane.org ([80.91.229.2]:50962 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934119AbXLTOX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:23:26 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Matthew Bloch <matthew@bytemark.co.uk>
Subject: Re: Testing RAM from userspace / question about memmap= arguments
Date: Thu, 20 Dec 2007 14:17:10 +0000
Message-ID: <fkdth6$d7g$1@ger.gmane.org>
References: <fk8umh$n7o$1@ger.gmane.org> <1198154013.3205.124.camel@perihelion>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: desk2.office.bytemark.co.uk
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
In-Reply-To: <1198154013.3205.124.camel@perihelion>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Masters wrote:
> On Tue, 2007-12-18 at 17:06 +0000, Matthew Bloch wrote:
> 
>> I can see a few potential problems, but since my understanding of the
>> low-level memory mapping is muddy at best, I won't speculate; I'd just
>> appreciate any more expert views on whether this does work, or could be
>> made to work.
> 
> Yo,
> 
> I don't think your testing approach is thorough enough. Clearly (knowing
> your line of business - as a virtual machine provider), you want to do
> pre-production testing as part of your provisioning. I would suggest
> instead of using mlock() from userspace of simply writing a kernel
> module that does this for every page of available memory.

Yes this is to improve the efficiency of server burn-ins.  I would
consider a kernel module, but I still wouldn't be able to test the
memory in which the kernel is sitting, which is my problem.  I'm not
sure even a kernel module could reliably test the memory in which it is
residing (memtest86+ relocates itself to do this).  Also I don't see how
  userspace testing is any less thorough than doing it in the kernel; I
just need a creative way of accessing every single page of memory.

I may do some experiments with the memmap args, some bad RAM and
shuffling it between DIMM sockets when I have the time :)

-- 
Matthew

