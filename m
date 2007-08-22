Return-Path: <linux-kernel-owner+w=401wt.eu-S1764548AbXHVWfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764548AbXHVWfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762947AbXHVWey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:34:54 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:49332 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758569AbXHVWex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:34:53 -0400
Date: Wed, 22 Aug 2007 15:34:24 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: James Courtier-Dutton <James@superbug.demon.co.uk>
Cc: Chris Wright <chrisw@sous-sol.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Zachary Amsden <zach@vmware.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
Message-ID: <20070822223424.GE3672@sequoia.sous-sol.org>
References: <46CBC842.4070100@vmware.com> <46CCB088.8070606@goop.org> <46CCB56F.8090308@superbug.co.uk> <20070822222036.GD3672@sequoia.sous-sol.org> <46CCB8BA.6060007@superbug.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CCB8BA.6060007@superbug.demon.co.uk>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* James Courtier-Dutton (James@superbug.demon.co.uk) wrote:
> Ok, so I need to get a new CPU like the Intel Core Duo that has VT
> features? I have an old Pentium 4 at the moment, without any VT features.

Depends on your goals.  You can certainly give a paravirt Xen guest[1]
physical hardware without any VT extentions.  But that guest will be
able to DMA anywhere in memory without VT-d, so if it's an untrusted
guest you'd be taking a huge risk.

thanks,
-chris

[1] Note: this is with the xenbits.xensource.com kernel, not with a
kernel you'll get from kernel.org ATM.
