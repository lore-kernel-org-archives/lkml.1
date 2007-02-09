Return-Path: <linux-kernel-owner+w=401wt.eu-S1946379AbXBILuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946379AbXBILuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 06:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946387AbXBILuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 06:50:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39951 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946379AbXBILuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 06:50:50 -0500
From: Andi Kleen <ak@muc.de>
To: virtualization@lists.osdl.org
Subject: Re: [PATCH 6/10] lguest code: the little linux hypervisor.
Date: Fri, 9 Feb 2007 12:50:06 +0100
User-Agent: KMail/1.9.5
Cc: Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Paul Mackerras <paulus@samba.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1171012296.2718.26.camel@localhost.localdomain> <1171018812.2718.66.camel@localhost.localdomain> <45CC5771.1070309@vmware.com>
In-Reply-To: <45CC5771.1070309@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091250.06482.ak@muc.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Yes, it is a bit, umm, innovative.  If it is going to be kept, even if 
> just for devel logging, you should disable interrupts around it.  
> Changing segments is not a normal thing to do.

Actually that wouldn't be needed because interrupts are not allowed to do any 
user accesses. And contrary to the name it doesn't actually change
the segment registers, only state used by *_user.

-Andi
