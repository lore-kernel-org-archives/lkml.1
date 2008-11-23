Return-Path: <linux-kernel-owner+w=401wt.eu-S1757828AbYKWT35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828AbYKWT35 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 14:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbYKWT3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 14:29:49 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52197 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbYKWT3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 14:29:48 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] sysrq-j: emergency shell
From: Andi Kleen <andi@firstfloor.org>
References: <20081121235159.GA15861@localhost.localdomain>
	<20081122172702.GB2748@x200.localdomain>
	<20081122190719.3ef24df6@lxorguk.ukuu.org.uk>
	<19f34abd0811221448p34770633keb5ea97f8e9bf62d@mail.gmail.com>
	<20081123001035.64234982@lxorguk.ukuu.org.uk>
Date: Sun, 23 Nov 2008 20:29:49 +0100
In-Reply-To: <20081123001035.64234982@lxorguk.ukuu.org.uk> (Alan Cox's message of "Sun, 23 Nov 2008 00:10:35 +0000")
Message-ID: <871vx2jl5e.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> But I realize that this does not necessarily mean that the other
>> processes cannot read from or write to the tty anymore. Do you know
>> how to do that? :-)
>
> When you have control vhangup()

It also means more people have to disable sysrq than before.

AFAIK currently it's not possible to actually change anything 
with sysrq (just reboot/kill/show information). That would
be the first one who could be actually used to change
data, enable network login etc.

I bet this unexpected change of security policy would
surprise a lot of existing users and suddenly give
a new attack vector.

So if this is added it should at least have a separate
enable switch with default off. But as Alan says, we
have vt-switch anyways so ...

-Andi

-- 
ak@linux.intel.com
