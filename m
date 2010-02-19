Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab0BSAIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 19:08:11 -0500
Received: from borg.medozas.de ([188.40.89.202]:47500 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab0BSAII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 19:08:08 -0500
Date: Fri, 19 Feb 2010 01:08:07 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jean Delvare <khali@linux-fr.org>, "J.H." <warthog9@kernel.org>,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>, users@kernel.org,
       lasse.collin@tukaani.org, linux-kernel <linux-kernel@vger.kernel.org>,
       mirrors@kernel.org
Subject: Re: [kernel.org users] XZ Migration discussion
In-Reply-To: <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain>
Message-ID: <alpine.LSU.2.01.1002190106070.1233@obet.zrqbmnf.qr>
References: <4B744E13.8040004@kernel.org> <20100212150137.648dca7c@hyperion.delvare> <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2010-02-12 16:21, Linus Torvalds wrote:
>On Fri, 12 Feb 2010, Jean Delvare wrote:
>> 
>> Maybe that's just me, but my main concern is neither download times nor
>> decompression times. My main concern is the access time to directory
>> indexes when browsing the kernel archive, because there are 5 entries
>> for every patch or tarball: .bz2, .bz2.sign, .gz, .gz.sign and .sign.
>> This is horribly slow.
>
>This was actually the main reason for me personally to ask about just 
>dropping support for .gz files - not because I care deeply about how much 
>disk space kernel.org wastes, but because the long directory listings make 
>it slower for me to mentally index the directory.

Can I feature-request that someone reduces the git.kernel.org frontpage?
It's almost twice as large as the v2.6 dir index in http-delivered form,
so you can already experience what it's like when v2.6/ grows bigger.
