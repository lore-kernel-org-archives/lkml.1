Return-Path: <linux-kernel-owner+w=401wt.eu-S1946362AbXBQBiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946362AbXBQBiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 20:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946363AbXBQBiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 20:38:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:60386 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946362AbXBQBiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 20:38:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC] killing the NR_IRQS arrays.
Date: Sat, 17 Feb 2007 02:37:42 +0100
User-Agent: KMail/1.9.5
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com> <20070216195256.GE2572@flint.arm.linux.org.uk> <1171665426.5644.99.camel@localhost.localdomain>
In-Reply-To: <1171665426.5644.99.camel@localhost.localdomain>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
X-Legal: Vorsitzender des Aufsichtsrats: Johann Weihen=0A=0D Gesch=E4ftsf=FChrung: Herbert Kircher=0A=0D Sitz der Gesellschaft: B=F6blingen=0A=0D Registergericht: Amtsgericht Stuttgart, HRB 243294
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702170237.42910.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX19M6azmSJQGnIC2uNsf53Arp4dAsDHe1oWtoIKCyI20INQWrpMy6FFjsq6uCQuAW8COe/0x7YCpYJxyO0ry+0fwjqFMZL+rgypKhNYFt5bJCQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 February 2007 23:37, Benjamin Herrenschmidt wrote:
> You might want to have a look at the powerpc API with it's remaping
> capabilities. It's very nice for handling multiple domain spaces. It
> might be of some use for you.

I don't consider the powerpc virtual IRQs a solution for the problem.
While I believe you did the right thing for powerpc with generalizing
this over all its platforms, it really isn't more than a workaround
for the problem that we can't deal well with the static irq_desc
array.

When that problem is now getting worse on other architectures, we
should try to get it right on all of them, rather than spreading
the workaround further.

	Arnd <><
