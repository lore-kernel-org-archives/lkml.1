Return-Path: <linux-kernel-owner+w=401wt.eu-S1757128AbYF0NVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128AbYF0NVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 09:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbYF0NVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 09:21:01 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:42009 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbYF0NVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 09:21:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=In-Reply-To:Received:Date:Cc:To:From:Subject:Mime-Version:Message-Id:Content-Transfer-Encoding:Content-Type:X-Abuse:X-Seznam-User:X-QM-Mark;
	b=mrkNW5ZoUhgTKxqkLUpHtkRRXWuSmvlbopWf+9t704HfJ7UVzPaCX4rIuOdOZ6sxx
	2YWb721hlyJGfnmiGebClm0+PGR4eqtXMvn5mNjvjtj3i+VUPOLEyS6I+OF8B8DXBk5
	KThs7Dd9WRQA1z9vlDnkEtTBtt1m1VFNLjZLqcE=
In-Reply-To: <20080627115936.GA18644@cs181140183.pp.htv.fi>
Date: Fri, 27 Jun 2008 15:19:34 +0200 (CEST)
Cc: =?us-ascii?Q?Arnd=20Bergmann?= <arnd@arndb.de>, linux-arch@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk,
       =?us-ascii?Q?Michal=20Simek?= <monstr@monstr.eu>, vapier.adi@gmail.com,
       matthew@wil.cx, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, drepper@redhat.com,
       linuxppc-dev@ozlabs.org, will.newton@gmail.com, hpa@zytor.com,
       John.Linn@xilinx.com, john.williams@petalogix.com
To: =?us-ascii?Q?Adrian=20Bunk?= <bunk@kernel.org>
From: =?us-ascii?Q?Michal=20Simek?= <Monstr@seznam.cz>
Subject: =?us-ascii?Q?Re=3A=20=5BPATCH=2048=2F60=5D=20microblaze=5Fv4=3A=20headers=20simple=20files=20=2D=20empty=20or=20redirect=20to=20asm=2Dgeneric?=
Mime-Version: 1.0
Message-Id: <4641.7464-1541-432171441-1214572774@seznam.cz>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset="us-ascii"
X-Abuse: abuse@seznam.cz
X-Seznam-User: Monstr@seznam.cz
X-QM-Mark: email-qm1<166249559>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian and Arnd,

>> > After all, it won't matter whether we'll unify resp. remove
>> > 22 or 23 files.
>> 
>> That wasn't my idea. The logic was that if one more file exists
>> in asm-generic that can be removed from the architectures,
>> we get 22 more files to remove without anyone having to look
>> at the big picture. When microblaze is in,
>
>Discussions of the "big picture" should be in an own thread, not as 
>part of a merge of a new architecture.
>
>I am not an architecture maintainer, but I do not like the way you want 
>to couple the microblaze merge with the move of stuff to asm-generic.
>
>They both make sense, but they are clearly separate issues.
>
>> I can compile a list
>> with asm-generic files that can be used to replace the architecture
>> specific files, so the arch maintainers can decide on their own
>> whether to clean their own stuff up or not.
>>...
>
>We need either all architectures changed or none at all - we do need the 
>arch headers to become more similar, not more different.
>
>And this is why we need an agreement _before_ an asm-generic header gets 
>added, not after it.

I moved some headers to asm-generic how Arnd recommended to me. The same style
is applied to of files. If you think that is good idea to start with new topic what is necessary to move
to asm-generic, I agree. For me is not hard to move these files back to asm-microblaze and then
someone can do big patch among all archs.
If you want to managed, please open new discussion about and cc me.

Michal
