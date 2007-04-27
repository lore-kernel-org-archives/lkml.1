Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbXD0Uut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbXD0Uut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 16:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757234AbXD0Uus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 16:50:48 -0400
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:47103 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757222AbXD0Utr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 16:49:47 -0400
X-YMail-OSG: y9u4GFAVM1lSnko0_de631CasXG6lBCufWGg6FUaKWyV7RGcY3HE1AuQnrNRKR17G1sFFB4t3g--
Date: Fri, 27 Apr 2007 13:42:07 -0700
From: Chris Wedgwood <cw@f00f.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
Subject: Re: [PATCH 0/5] fallocate system call
Message-ID: <20070427204207.GA29551@tuatara.stupidest.org>
References: <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070427121003.GA7808@osiris.boeblingen.de.ibm.com> <20070427144327.GC22949@lazybastard.org> <20070427174613.GA8228@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427174613.GA8228@osiris.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 07:46:13PM +0200, Heiko Carstens wrote:

> If one insists to have fd at first argument, what is wrong with
> having u32 arguments only?

Well, I was one of those who objected as it seems *UGLY* to me.

> It's not that this syscall comes even close to what can be
> considered performance critical...

Right.

> It adds userspace overhead for one architecture. Every *trace and
> *libc needs special handling on s390 for this syscall. I would
> prefer to avoid this.

I'm not that bothered about it.  I would prefer it did use clean
64-bit arguments, but given it's a non-critical syscall I'm don't
think the aesthetics are worth impossing crud on s390 for.


