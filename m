Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbZFCX3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbZFCX3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 19:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754452AbZFCX3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 19:29:08 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:50357 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754287AbZFCX3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 19:29:07 -0400
From: Frans Pop <elendil@planet.nl>
To: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Xen is a feature
Date: Thu, 4 Jun 2009 01:29:01 +0200
User-Agent: KMail/1.9.9
Cc: tglx@linutronix.de, george.dunlap@eu.citrix.com, davem@davemloft.net,
       jeremy@goop.org, mingo@elte.hu, dan.magenheimer@oracle.com,
       avi@redhat.com, xen-devel@lists.xensource.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, Keir.Fraser@eu.citrix.com,
       torvalds@linux-foundation.org, gregkh@suse.de, kurt.hackel@oracle.com,
       Ian.Pratt@eu.citrix.com, xen-users@lists.xensource.com,
       ksrinivasan@novell.com, EAnderson@novell.com, wimcoekaerts@wimmekes.net,
       stephen.spector@citrix.com, jens.axboe@oracle.com
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com> <alpine.LFD.2.00.0905311607560.3379@localhost.localdomain> <4A26D3D8.6080002@tmr.com> <alpine.LFD.2.00.0906032204220.3419@localhost.localdomain> <alpine.LFD.2.00.0906032204220.3419@localhost.localdomain> <4A26FB3B.6010205@tmr.com>
In-reply-To: <4A26FB3B.6010205@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906040129.07852.elendil@planet.nl>
X-OriginalArrivalTime: 03 Jun 2009 23:29:08.0344 (UTC) FILETIME=[17987780:01C9E4A3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> I was referring to your "no benefit" comment, I don't dispute the
> technical issues. I think the idea of moving the hypervisor into the
> kernel and letting xen folks do the external parts as they please.

Where does that come from? AFAICT Thomas never made a "no benefit" comment 
other than limited to the context of the technical implementation.
I've always understood his meaning in this thread to be: "the proposed 
patch set does not improve the technical standard of the linux kernel, 
but would instead lower it considerably".
Thomas has been extremely correct in this thread and IMO does not deserve 
this attack.

Let's look at his exact comments (emphasis mine).

! The kernel policy always was and still is to accept only those
! features which have a technical benefit **to the code base**.

and

! Aside of the paravirt, which seems to expand through arch/x86 like a
! hydra, the new patches sprinkle "if (xen_...)" all over the
! place. These extra xen dependencies are no improvement, they are a
! royal pain in the ...

Also clearly limited to technical implementation.

! I really have a hard time to see why dom0 support makes Linux more
! useful **to people who do not use it**. It does not improve the Linux
! experience **of Joe User** at all.

Or has Thomas made some "no benefit" comment I've missed?

Cheers,
FJP
