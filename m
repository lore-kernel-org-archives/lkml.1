Return-Path: <linux-kernel-owner+w=401wt.eu-S1761410AbXGWGif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761410AbXGWGif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757587AbXGWGi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:38:26 -0400
Received: from rzcomm12.rz.tu-bs.de ([134.169.9.59]:56209 "EHLO
	rzcomm12.rz.tu-bs.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758065AbXGWGiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:38:25 -0400
Message-ID: <46A44CD0.8020508@l4x.org>
Date: Mon, 23 Jul 2007 08:38:08 +0200
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Thunderbird 2.0.0.5pre (Windows/20070717)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Trivial sh64 updates for 2.6.23-rc1
References: <20070720091707.GA26717@linux-sh.org> <46A0C199.8050401@l4x.org> <20070720151543.GA28274@linux-sh.org> <46A33D03.3000105@l4x.org> <20070722114253.GA11519@linux-sh.org> <46A3882C.7040709@l4x.org> <20070722204110.GA12101@linux-sh.org>
In-Reply-To: <20070722204110.GA12101@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> On Sun, Jul 22, 2007 at 06:39:08PM +0200, Jan Dittmer wrote:
>> Paul Mundt wrote:
>>> It's known that empty objects require explicit tuning for the ABI,
>>> however, this has never been anything that was fatal. If you flip
>>> something on within each of those subsystems, does the error go away?
>> Yes, thanks this fixes it. Would you accept a patch to modify the
>> defconfig so that it builds by default? Would be most useful for
>> my pet project (http://l4x.org/k/). A fixed toolchain would of course
>> also be nice.
>>
> I'll certainly apply patches that help getting it building, so feel free
> to send updates for that. As I also noted, the empty object thing is
> non-fatal with my toolchain, so I'd also appreciate it if you could put
> a tarball of yours up somewhere so this is a bit easier to verify. I
> suspect this is just something we're going to have to change in binutils,
> however.

You can find it here:

http://l4x.org/~jdittmer/sh64-linux-binutils-2.17-gcc-4.1.3pre.tar.bz2

binutils 2.17.50.0.17 (from ftp.kernel.org)
gcc 4.1.3 prerelease (svn, fixes a build bug for sh64)

Jan

