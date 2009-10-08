Return-Path: <linux-kernel-owner+w=401wt.eu-S1758535AbZJHPVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535AbZJHPVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 11:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758497AbZJHPVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 11:21:24 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:59122 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758489AbZJHPVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 11:21:23 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.32-rc3
Date: Thu, 8 Oct 2009 17:20:44 +0200
User-Agent: KMail/1.9.9
Cc: mingo@elte.hu, hohndel@infradead.org, lenb@kernel.org,
       linux-kernel@vger.kernel.org
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain>
In-reply-To: <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910081720.45850.elendil@planet.nl>
X-OriginalArrivalTime: 08 Oct 2009 15:20:45.0491 (UTC) FILETIME=[E8323030:01CA482A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Once you start believing the lie, suddenly all the subtrees will start
> thinking that now _their_ kernel versions are bad, so now they'll start
> to want to make the same idiotic changes to their Makefiles, or maybe
> they'll decide that they don't want to pull tagged releases, but the "one
> after the tag so that they'll get the updated Makefile".

After sleeping on it and letting it percolate a bit I understand this 
argument better, and accept it.

I'll continue to increase SUBLEVEL and add -rc0 for my own builds though, 
as IMHO it still makes perfect sense for versioning and managing installed 
kernel packages.

The conclusion for me is: if anyone wants -rc0, simply apply it locally.


I don't see myself ever using AUTOVERSION. The reason is that I don't want 
the files in /boot and dirs in /lib/modules/ to include the commit ID.

For me the kernel *version* is what's defined in the Makefile (plus any 
localversion extentions). That's how I want it installed. The AUTOVERSION 
part is a *revision*: an update to the tagged version.
(I don't expect you to agree with this.)

So, unless it is made possible to include AUTOVERSION in the kernel and 
display it in dmesg and as part of the full 'uname -a' info *without* it 
becoming part of 'uname -r', it is not a usable option for me. Sorry.

Cheers,
FJP
