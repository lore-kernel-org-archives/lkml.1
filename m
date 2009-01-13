Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbZAMSz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbZAMSz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbZAMSzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:55:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57749 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbZAMSzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:55:49 -0500
Message-ID: <496CE3A2.4060605@zytor.com>
Date: Tue, 13 Jan 2009 10:55:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: [PATCH -tip] x86: headers - fix export private data to	userspace
References: <20090113183456.GA14470@localhost> <1231871832.16221.1.camel@brick> <496CE234.2070900@zytor.com> <20090113185239.GC14470@localhost>
In-Reply-To: <20090113185239.GC14470@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> | > 
> | >> 4) setup.h - COMMAND_LINE_SIZE saved for userspace, bootloaders
> | >>    could use it.
> | > 
> | > Doesn't this need to be (at least) _COMMAND_LINE_SIZE to avoid
> | > polluting the namespace, not sure it can be changed though as the
> | > horse is already out of the barn.
> | 
> | No, this is not one of those cases, but it's worth explaining why.
> | 
> | You can introduce symbols into the general namespace if *and only if*
> | they are in a header file that is invoked directly by the user.  In
> | other words, such a header file is unusable by libc, but setup.h doesn't
> | contain anything needed by libc in the first place.
> | 
> | 	-hpa
> | 
> 
> So we could just fence it by __KERNEL__?
> 

We might, as userspace shouldn't need COMMAND_LINE_SIZE anyway (see
other post), but I'm rather confused as how you got that from what I
wrote above.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

