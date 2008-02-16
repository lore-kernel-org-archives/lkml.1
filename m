Return-Path: <linux-kernel-owner+w=401wt.eu-S1757791AbYBPTvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbYBPTvI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 14:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbYBPTu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 14:50:56 -0500
Received: from www.tglx.de ([62.245.132.106]:41892 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218AbYBPTuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 14:50:55 -0500
Date: Sat, 16 Feb 2008 20:50:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux390@de.ibm.com,
       linux-s390@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUG] 2.6.25-rc2-mm1 - kernel oops while bootup on s390x
In-Reply-To: <alpine.LFD.1.00.0802162048120.7583@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.00.0802162050020.7583@apollo.tec.linutronix.de>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B70C3A.4050600@linux.vnet.ibm.com> <20080216114527.48408288.akpm@linux-foundation.org> <alpine.LFD.1.00.0802162048120.7583@apollo.tec.linutronix.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-898888635-1203191434=:7583"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-898888635-1203191434=:7583
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Sat, 16 Feb 2008, Thomas Gleixner wrote:
> On Sat, 16 Feb 2008, Andrew Morton wrote:
> > > The 2.6.25-rc2-mm1 kernel panic's while boot up on the s390x
> > > 
> > > Unable to handle kernel pointer dereference at virtual kernel address 0000000000
> > > 000000
> > > Oops: 0004 #1¨ SMP
> > First question is: does this happen in current mainline?
> > 
> > If not, it would be useful if someone could test futex-fix-init-order.patch
> > and futex-runtime-enable-pi-and-robust-functionality.patch on curent
> > mainline, because those are planned for 2.6.25.
> 
> See: http://lkml.org/lkml/2008/2/16/109
> 
> It unearthed a BUG in the S390 exception fixup tables :)

Oops, wrong reference.

      http://lkml.org/lkml/2008/2/16/95

Thanks,
	tglx
--8323328-898888635-1203191434=:7583--
