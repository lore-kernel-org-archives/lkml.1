Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbYFAJLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbYFAJLS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 05:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbYFAJLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 05:11:06 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:37946 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbYFAJLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 05:11:05 -0400
Date: Sun, 1 Jun 2008 11:11:01 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: David Newall <davidn@davidnewall.com>
cc: Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support
In-Reply-To: <48423B8A.20505@davidnewall.com>
Message-ID: <alpine.LNX.1.10.0806011105450.4055@fbirervta.pbzchgretzou.qr>
References: <200805311737.58991.arnd@arndb.de> <48419F45.20908@davidnewall.com> <200805312240.50720.arnd@arndb.de> <48423B8A.20505@davidnewall.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2008-06-01 08:02, David Newall wrote:
>>   
>>> I prefer the technique of union of a tmpfs over some other fs
>>
>> You're right in principle, but unfortunately there is to date no working
>> implementation of union mounts. Giving users the option of using an
>> existing file system with a few tweaks can only be better than than
>> forcing them to use hacks like unionfs.
>
>I've not used unionfs (nor aufs) so I'm not aware of its foibles, but I
>can say that it's the right kind of solution.  Rather than spend effort
>implementing write support for read-only filesystems, why not put your
>time into fixing whatever you see wrong with one or both of those?

I have to join in. Unionfs and AUFS may be bigger in bytes than the
embedded developer wants to sacrifice, but that is what it takes for
a solid implementation that has to deal with things like NFS and
mmap. Even so, there is a fs called mini_fo you can try using if
you disagree with the size of unionfs/aufs, at the cost of not having
support for all corner cases.
