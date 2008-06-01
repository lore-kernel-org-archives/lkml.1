Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbYFAGDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbYFAGDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 02:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbYFAGDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 02:03:03 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:41234 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751670AbYFAGDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 02:03:01 -0400
Message-ID: <48423B8A.20505@davidnewall.com>
Date: Sun, 01 Jun 2008 15:32:50 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support
References: <200805311737.58991.arnd@arndb.de> <48419F45.20908@davidnewall.com> <200805312240.50720.arnd@arndb.de>
In-Reply-To: <200805312240.50720.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Saturday 31 May 2008, David Newall wrote:
>   
>> I prefer the technique of union of a tmpfs over some other fs
>>     
>
> You're right in principle, but unfortunately there is to date no working
> implementation of union mounts. Giving users the option of using an
> existing file system with a few tweaks can only be better than than
> forcing them to use hacks like unionfs.

I've not used unionfs (nor aufs) so I'm not aware of its foibles, but I
can say that it's the right kind of solution.  Rather than spend effort
implementing write support for read-only filesystems, why not put your
time into fixing whatever you see wrong with one or both of those?
