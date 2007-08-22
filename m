Return-Path: <linux-kernel-owner+w=401wt.eu-S934263AbXHVXOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934263AbXHVXOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 19:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763259AbXHVXOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 19:14:41 -0400
Received: from gw.goop.org ([64.81.55.164]:39625 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761913AbXHVXOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 19:14:40 -0400
Message-ID: <46CCC361.6020600@goop.org>
Date: Wed, 22 Aug 2007 16:14:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: James Courtier-Dutton <James@superbug.demon.co.uk>
CC: Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
References: <46CBC842.4070100@vmware.com> <46CCB088.8070606@goop.org> <46CCB56F.8090308@superbug.co.uk> <20070822222036.GD3672@sequoia.sous-sol.org> <46CCB8BA.6060007@superbug.demon.co.uk>
In-Reply-To: <46CCB8BA.6060007@superbug.demon.co.uk>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Courtier-Dutton wrote:
> Ok, so I need to get a new CPU like the Intel Core Duo that has VT
> features? I have an old Pentium 4 at the moment, without any VT features.
>   

No, VT-d (as opposed to VT) is a chipset feature which allows the
hypervisor to control who's allowed to DMA where.  So you'd need a very
new machine with a VT-d capable chipset (which would also have VT, since
all new processors do).

    J
